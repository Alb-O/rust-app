{ pkgs, ... }:

{
  env = {
    SERVICE_NAME = "order-quote-cli";
  };

  packages = [
    pkgs.jq
  ];

  scripts = {
    base-toolchain.exec = ''
      rustc --version
      cargo --version
    '';

    quote-example.exec = ''
      cargo run -- quote 12500 15 express --fragile | jq .
    '';

    health.exec = ''
      cargo run -- health | jq .
    '';
  };

  enterShell = ''
    echo "Run: quote-example"
    echo "Run: health"
  '';

  enterTest = ''
    set -euo pipefail

    rustc --version | grep -E "nightly|dev"
    cargo run -- health | jq -e '.status == "ok"'
    cargo run -- quote 12500 15 overnight --fragile | jq -e '.eta_days == 1'
    cargo check --all-targets --all-features
    cargo test --all-targets --all-features
  '';
}
