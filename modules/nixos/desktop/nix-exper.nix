{ ... }:
{
  nix.settings.experimental-features = [
    "auto-allocate-uids"
    "cgroups"
    #"ca-derivations"
    "daemon-trust-override"
    "dynamic-derivations"
    "fetch-closure"
    "impure-derivations"
    "parse-toml-timestamps"
    "read-only-local-store"
    "recursive-nix"
  ];
}
