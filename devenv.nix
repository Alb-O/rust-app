{ ... }:

{
  scripts.base-toolchain.exec = ''
    rustc --version
    cargo --version
  '';

  enterTest = ''
    set -euo pipefail
    rustc --version | grep -E "nightly|dev"
    cargo check --all-targets --all-features
  '';
}
