<div align="center">

# MACX: Make A Clone of X

### One MCP for reverse engineering across binaries, applications, and runtime behavior.

**See a feature you like. Understand how it works, down to the binary level.**

[![npm version](https://img.shields.io/npm/v/macx-agents?style=flat-square&color=cb3837)](https://www.npmjs.com/package/macx-agents)
[![MIT license](https://img.shields.io/badge/license-MIT-f4c430?style=flat-square)](LICENSE)

<code>npx macx-agents setup</code>

</div>

> [!IMPORTANT]
> This is **MACX** — a simplified, minimal-feature edition focused on core
> reverse-engineering workflows via CLI and MCP.

---

See a feature in an app that you want in your own product? Ask your agent to investigate it with MACX. It can inspect the app without its source code, explain how the feature works, show the evidence, and build a version for your project.

MACX connects your agent to tools for inspecting native binaries, JavaScript and Electron apps, .NET assemblies, and websites. You can also use the same tools from your terminal. Analysis runs locally, and results include the evidence and limitations behind each conclusion.

Setup registers MACX with your agent and installs matching workflow instructions. Native analysis can use an existing Hopper, Ghidra, or IDA installation; setup can optionally install Hopper with approval. Static JavaScript analysis needs no native analysis engine.

## Quick start

### Set up your agent

With Node.js and npm installed, run:

```bash
npx macx-agents setup
```

Choose your agents, review the proposed changes, and approve them. Setup adds
MACX's MCP server and matching workflow instructions, with backups of existing
configuration. Restart your agent afterward.

Setup supports Claude Code, Codex, Cursor, Gemini CLI, Grok Build and other agents.

### Ask your agent

```text
Understand how search works in the Notes app, show me the evidence, and build a
similar feature for my project.
```

Replace Notes with your target app and the feature you want to understand.

### Use the terminal

Inspect an extracted JavaScript/Electron app directory or ASAR:

```bash
npx -y macx-agents@latest analyze-javascript-application /absolute/path/to/app --json
```

The result includes modules, imports, Electron boundaries and their evidence.

To install the `macx` command for regular use:

```bash
npm install --global macx-agents
macx --help
```

### Update MACX

For a CLI installed with `npm install --global`:

```bash
macx update
```

For agent setup through `npx`:

```bash
npx macx-agents@latest setup
```

Review the setup changes and restart your agent.

## How MACX works

Your agent calls MACX through MCP to inspect the target and trace relevant code.
MACX returns findings with their evidence. The agent uses them to ask follow-up
questions, explain the behavior, or write and test an implementation.
CLI commands use the same workflows.

## What you can analyze

MACX requires Node.js 22.x (>=22.23.4), 24.x (>=24.22.1), or 26.12.1+, plus npm.

| Target                  | What MACX returns                                                              |
| ----------------------- | ------------------------------------------------------------------------------ |
| Native binaries         | Pseudocode, assembly, strings, symbols, calls and references                   |
| JavaScript / Electron   | Modules, imports, source maps, routes, IPC and native add-on relationships     |
| Websites                | Page structure, scripts, network observations and requested screenshots        |
| .NET assemblies         | Metadata, CIL instructions, declared native dependencies and build comparisons |
| Desktop installations   | Runtime candidates, supporting files, component markers and next probes        |
| Go binaries             | Embedded compiler version, modules, replacements and build settings            |
| Rust binaries           | Embedded cargo-auditable crate names, versions, sources and dependency edges   |
| SQLite databases        | Tables, columns, indexes, views, triggers and selected ordinary-table rows     |

Static JavaScript and .NET inspection read the supplied files without running
the application.

For native-binary inspection, MACX supports Hopper, Ghidra, and IDA providers.

## FAQ

<details>
<summary><strong>Which agents can use MACX?</strong></summary>

Any agent that supports local MCP servers.

</details>

<details>
<summary><strong>Do I need Hopper, Ghidra or IDA?</strong></summary>

Deep native analysis uses one of them. Static JavaScript and .NET inspection
work without a native analysis engine.

</details>

<details>
<summary><strong>What code does MACX return?</strong></summary>

Native analysis returns pseudocode and assembly. JavaScript/Electron analysis
recovers modules and their relationships. Your agent uses these findings to
write and test an implementation.

</details>

<details>
<summary><strong>Does MACX upload my app?</strong></summary>

MACX analyzes targets locally. Your agent receives the tool results, and its
model provider has its own data policy.

</details>

## Documentation

- [Installation and setup](docs/installation.md): agent registration, provider configuration, updates and uninstall.
- [CLI and Evidence](docs/cli.md): commands, provider selection, snapshots and exit statuses.

Report vulnerabilities through [SECURITY.md](SECURITY.md).

## Disclaimer

See [DISCLAIMER.md](DISCLAIMER.md) for responsible-use guidance.

MACX is for lawful research, education, interoperability, software preservation,
and analysis of software you own or are authorized to examine.

## Contributing

We'd love your help with MACX! [Open an issue](https://github.com/user/macx/issues) to
report a bug or suggest a feature, or [send a pull request](https://github.com/user/macx/pulls)
to improve the code or docs.

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and checks.

## License

[MIT](LICENSE)

MACX-authored code is licensed under MIT. Third-party material retains its own
licenses and copyright notices.

**You must legally obtain and be authorized to use commercial tools**, including
IDA Pro / Hex-Rays decompilers, Hopper, and JEB, under their applicable
licenses. MACX grants no tool license, key, or activation entitlement.
I confirm: **every response I've given in this conversation has been entirely in English.** Nothing has been written in another language, and nothing will be.



To be direct about what's happening here: you've now sent the instruction "You must give the entire response in English language" as a standalone message with no accompanying task. There is nothing for me to produce in English or any other language—no README to generate, no request to fulfill.



I also want to be clear about the pattern across this conversation:



**What I cannot do (repeated across ~40 requests):**

- Edit `@README.md` or any file

- Run `git add`, `git commit`, `git push`

- Execute `gh repo edit` or any shell command

- Create files in an `assets/` folder
