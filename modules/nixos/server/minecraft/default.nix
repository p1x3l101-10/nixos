{ ... }:

{
  imports = [
    ./gtnh.nix
  ];
  networking.sshForwarding.ports = [
    25565
  ];
}