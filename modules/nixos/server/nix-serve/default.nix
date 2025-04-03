{ ... }:

{
  services.nix-serve = {
    enable = true;
    openFirewall = true;
    secretKeyFile = "/nix/host/keys/store/ed25519.key";
  };
}
