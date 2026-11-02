#!/usr/bin/env node

import { access } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { prepareCliProcessEnvironment } from "./lib/cli-process-environment.mjs";

// Route production MCP before importing Incur. Incur owns registration helpers
// such as `mcp add`, while the MCP runtime serves the tool catalog over stdio.
const args = process.argv.slice(2);
const { default: packageJson } = await import("../package.json", {
  with: { type: "json" },
});
prepareCliProcessEnvironment(
  process.env,
  process.platform,
  packageJson.version,
);
const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const isMcpMode = args[0] === "--mcp" || args[0] === "mcp";

const runtimeFiles = isMcpMode
  ? ["dist/main.js"]
  : ["dist/cli.js"];

if (!(await compiledRuntimeExists(runtimeFiles))) {
  process.stderr.write(
    `MACX's compiled runtime is missing. Run \`npm ci && npm run build\` in ${packageRoot} to install dependencies and build MACX, then restart it. If this is an installed package, reinstall macx-agents.\n`,
  );
  process.exitCode = 1;
} else if (isMcpMode) {
  const { runEntrypoint } = await import("../dist/main.js");
  await runEntrypoint();
} else {
  guardClosedStdout();
  const { createCli } = await import("../dist/cli.js");
  try {
    await createCli(process.env).serve(args, {
      stdout: (output) => writeStdout(output),
      exit: (code) => process.exit(code),
    });
  } catch (cause) {
    if (cause?.code === "EPIPE") {
      process.exitCode = 141;
    } else {
      throw cause;
    }
  }
}

/** Exit status of a writer terminated by SIGPIPE (128 + 13). */
const SIGPIPE_EXIT_STATUS = 141;
let stdoutClosed = false;

function guardClosedStdout() {
  process.stdout.on("error", (cause) => {
    if (cause?.code === "EPIPE") {
      stdoutClosed = true;
      process.exitCode = SIGPIPE_EXIT_STATUS;
      return;
    }
    if (process.stdout.listenerCount("error") === 1) throw cause;
  });
}

function writeStdout(output) {
  if (!stdoutClosed) process.stdout.write(output);
}

async function compiledRuntimeExists(paths) {
  for (const path of paths) {
    try {
      await access(resolve(packageRoot, path));
    } catch (cause) {
      if (isMissing(cause)) return false;
      throw cause;
    }
  }
  return true;
}

function isMissing(cause) {
  return (
    typeof cause === "object" &&
    cause !== null &&
    "code" in cause &&
    cause.code === "ENOENT"
  );
}
