{ ... }:

{
  nix.settings.experimental-features = [
    "ca-derivations"
    "dynamic-derivations"
    "git-hashing"
    "no-url-literals"
    "parse-toml-timestamps"
    "pipe-operators"
  ];
}
