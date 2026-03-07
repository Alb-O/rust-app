# Order Quote CLI (Consumer Repo)

Practical consumer example for the Rust polyrepo setup.

This repository imports:
- `github:Alb-O/rust-base-devenv-polyrepo` for the shared nightly Rust toolchain and checks.

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
quote-example
health
```

## Validate

```bash
devenv test
```
