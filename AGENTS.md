# Repository Guidelines

## Product and Authority

MACX is a local-only reverse-engineering tool with shared CLI/MCP workflows.
Distinguish observations, derivations, inferences, and unknowns; preserve
Evidence provenance and session semantics through both adapters.

## Architecture and Cleanup

Dependencies flow inward: domain semantics and contracts, provider adapters,
shared application workflows, then CLI/MCP adapters. Keep engine protocols and
provider-specific code out of domain/application layers.

## Performance

Optimize in this order:

1. Agent tokens and context. Return the smallest sufficient answer.
2. Analysis time. Reuse validated results and shared work.
3. CPU and memory. Avoid unnecessary work and copies.

## Development

Use [.nvmrc](.nvmrc) and `package.json#packageManager` for the pinned toolchain.

- `npm ci`: install locked dependencies.
- `npm run build`: build the runtime.
- `npm run test`: run tests.
- `npm run check:fast`: cached typecheck and lint.

Use Conventional Commit subjects and PR titles. Mark breaking changes with `!`
or a `BREAKING CHANGE:` footer.
