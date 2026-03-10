# Order Quote CLI (rust-app)

Practical app repo for the Rust polyrepo setup.

Uses `dvnv-rust-env` and `composer`.
Its `Cargo.toml` is generated from a repo-owned `Cargo.dvnv.toml` plus the shared
catalog built into `dvnv-rust-env`.
The base Rust environment and managed-Cargo behavior are imported from
`inputs.dvnv-rust-env` inside `devenv.nix`, so downstream repos can still build
`outputs.order-quote-cli`.

The app is a CLI used by commerce teams to generate shipping quotes.

## Commands

```bash
# health payload
cargo run -- health

# quote payload
cargo run -- quote 12500 15 express --fragile
```

## Devenv helpers

```bash
devenv shell
show-cargo-manifest
quote-example
health
packaged-health
```

## Output for other repos

This repo exports:

- `outputs.order-quote-cli`
- `outputs.composed_instructions` (composed instructions from the import chain)

Other repos can run:

```bash
${config.outputs.order-quote-cli}/bin/order-quote-cli health
```

## Validate

```bash
devenv test
```
