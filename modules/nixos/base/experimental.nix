{ ... }:

{
  nix.settings.experimental-features = [
    "ca-derivations"
    "dynamic-derivations"
    "git-hashing"
    "parse-toml-timestamps"
    "pipe-operators"
  ];
  # Stabilized, yet still used
  nix.settings = {
    lint-url-literals = "warn";
  };
}
