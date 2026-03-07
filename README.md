# Order Quote CLI (rust-app)

Practical app repo for the Rust polyrepo setup.

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
packaged-health
```

## Output for other repos

This repo exports a package output:
- `outputs.order-quote-cli`

Another repo can import this repo and execute:

```bash
${config.outputs.order-quote-cli}/bin/order-quote-cli health
```

## Validate

```bash
devenv test
```
