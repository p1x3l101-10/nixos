{ ... }:

{
  imports = [
    ./module.nix
    ./portRange.nix
  ];
  networking.sshForwarding = {
    enable = false;
    trustedHostKeys = [
      "[srv01.exsmachina.org]:2222 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+JEJ7SczOJCcn/bPGUySPXH0FUsXl8C2/wFY1r3g1h"
    ];
    sshPort = 2222;
    keyFile = "/nix/host/keys/ssh-tunnel/id.key";
  };
}
