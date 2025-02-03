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
    "no-url-literals"
    "parse-toml-timestamps"
    "read-only-local-store"
    "recursive-nix"
  ];
}
