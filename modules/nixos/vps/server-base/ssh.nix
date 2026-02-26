{ pkgs, lib, globals, ... }:

let
  inherit (globals.dirs) keys;
in {
  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkForce "yes";
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group-exchange-sha256"
      ];
    };
    ports = [ 2222 ];
    hostKeys = [
      {
        path = "${keys}/ssh/ed25519.key";
        type = "ed25519";
      }
    ];
  };
  # I use kitty to remote in, get the terminfo
  environment.systemPackages = [
    pkgs.kitty.terminfo
  ];
}
