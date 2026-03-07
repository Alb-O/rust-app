{ lib, pkgs, config, ... }:

let
  rustImportEval = builtins.tryEval config.languages.rust.import;
  hasRustImport = rustImportEval.success;
  orderQuoteCli =
    if hasRustImport then
      rustImportEval.value ./. {}
    else
      pkgs.rustPlatform.buildRustPackage {
        pname = "order-quote-cli";
        version = "0.1.0";
        src = ./.;
        cargoLock.lockFile = ./Cargo.lock;
      };
in
{
  env = {
    SERVICE_NAME = "order-quote-cli";
  };

  packages = [
    pkgs.jq
  ];

  scripts =
    {
      packaged-health.exec = ''
        ${orderQuoteCli}/bin/order-quote-cli health | jq .
      '';
    }
    // lib.optionalAttrs hasRustImport {
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

  outputs.order-quote-cli = orderQuoteCli;

  enterShell = ''
    echo "Run: packaged-health"
  '' + lib.optionalString hasRustImport ''
    echo "Run: quote-example"
    echo "Run: health"
  '';

  enterTest =
    if hasRustImport then
      ''
        set -euo pipefail

        rustc --version | grep -E "nightly|dev"
        cargo run -- health | jq -e '.status == "ok"'
        cargo run -- quote 12500 15 overnight --fragile | jq -e '.eta_days == 1'
        cargo check --all-targets --all-features
        cargo test --all-targets --all-features
      ''
    else
      ''
        set -euo pipefail

        ${orderQuoteCli}/bin/order-quote-cli health | jq -e '.status == "ok"'
        ${orderQuoteCli}/bin/order-quote-cli quote 12500 15 overnight --fragile | jq -e '.eta_days == 1'
      '';
}
