# Contributing to MACX

MACX welcomes focused bug fixes, documentation improvements, tests, and
analysis workflows.

## Development setup

Use the development toolchain pinned in `.nvmrc` and
`package.json#packageManager`. Run `nvm use` before installing dependencies.

```bash
npm ci
npm run check:fast
```

`npm ci` installs the exact dependencies. Run `npm run build` when you need the
standalone CLI or MCP server; it compiles the TypeScript runtime.

## Development feedback

Select checks for the behavior changed. For a source edit:

```bash
npm run test
npm run check:fast
```

## Pull request ownership

AI-assisted contributions are welcome. Every PR must have a human owner who
takes responsibility for the complete change, including code, tests,
documentation, and claims produced with AI assistance.

## Reporting issues

Use the issue form and keep it concise. For bugs, include the actual result, the
shortest reproduction you ran, the tested version and environment, and the
smallest useful output.

## License

By contributing, you agree that your contributions will be licensed under the
MIT License.
