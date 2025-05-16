{ lib, ... }:

{
  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkForce "yes";
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group-exchange-sha256"
        "ssh-rsa-cert-v01@openssh.com"
      ];
    };
  };
}
