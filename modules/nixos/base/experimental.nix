{ ... }:

{
  nix.settings.experimental-features = [
    "auto-allocate-uids"
    "blake3-hashes"
    "ca-derivations"
    "cgroups"
    "configurable-impure-env"
    "dynamic-derivations"
    "fetch-closure"
    "fetch-tree"
    "git-hashing"
    "parse-toml-timestamps"
    "pipe-operators"
    "recursive-nix"
    "verified-fetches"
  ];
  # Stabilized, yet still used
  nix.settings = {
    lint-url-literals = "fatal";
  };
}
