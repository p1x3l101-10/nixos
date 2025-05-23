{ ... }:

{
  imports = [
    ./dont-dye-together.nix
  ];
  networking.sshForwarding.ports = [
    25565
  ];
}