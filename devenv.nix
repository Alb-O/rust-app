{
  inputs,
  pkgs,
  config,
  ...
}:

let
  standaloneProjectRoot = toString ./.;
  generatedSource = pkgs.runCommand "order-quote-cli-source" { } ''
    mkdir -p "$out"
    cp -R ${./.}/. "$out"/
    chmod -R u+w "$out"
    rm -f "$out/Cargo.toml"
    cp ${config.outputs.cargo_manifest} "$out/Cargo.toml"
  '';
  orderQuoteCli = pkgs.rustPlatform.buildRustPackage {
    pname = "order-quote-cli";
    version = "0.1.0";
    src = generatedSource;
    cargoLock.lockFile = ./Cargo.lock;
  };
in
{
  imports = [ (inputs.dvnv-rust-env + "/modules/managed-cargo") ];

  "rust-env".managedCargo = {
    enable = true;
    specPath = "${standaloneProjectRoot}/Cargo.dvnv.toml";
    outputPath =
      let
        currentProjectRoot = toString config.devenv.root;
      in
      if currentProjectRoot == standaloneProjectRoot then "Cargo.toml" else null;
  };

  composer.ownInstructions = {
    rust-app = [ (builtins.readFile ./AGENTS.md) ];
  };

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

    show-cargo-manifest.exec = ''
      cat ${config.outputs.cargo_manifest}
    '';

    packaged-health.exec = ''
      ${orderQuoteCli}/bin/order-quote-cli health | jq .
    '';
  };

  outputs.order-quote-cli = orderQuoteCli;

  enterShell = ''
    echo "Run: show-cargo-manifest"
    echo "Run: quote-example"
    echo "Run: health"
    echo "Run: packaged-health"
  '';

  enterTest = ''
    set -euo pipefail

    rustc --version | grep -E "nightly|dev"
    grep -F 'version = "1.0.228"' Cargo.toml
    grep -F 'version = "1.0.149"' Cargo.toml
    cargo run -- health | jq -e '.status == "ok"'
    cargo run -- quote 12500 15 overnight --fragile | jq -e '.eta_days == 1'
    cargo check --all-targets --all-features
    cargo test --all-targets --all-features
  '';
}
