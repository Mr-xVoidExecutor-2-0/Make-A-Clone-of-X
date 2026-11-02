import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    retry: 0,
    reporters: ["default"],
    testTimeout: 30_000,
    coverage: {
      enabled: false,
      provider: "v8",
      include: ["src/**"],
      thresholds: {
        statements: 50,
        branches: 50,
        functions: 50,
        lines: 50,
      },
      reporter: ["text", "text-summary"],
    },
  },
});
