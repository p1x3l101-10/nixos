{ lib, ... }:

{
  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkForce "yes";
    };
    hostKeys = [
      {
        bits = 4096;
        path = "/nix/host/keys/ssh/rsa.key";
        type = "rsa";
      }
      {
        path = "/nix/host/keys/ssh/ed25519.key";
        type = "ed25519";
      }
    ];
  };
}
