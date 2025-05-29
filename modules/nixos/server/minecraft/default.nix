{ ... }:

{
  imports = [
    ./dont-dye-together.nix
    ./bluemap-nginx.nix
  ];
  networking.sshForwarding.ports = [
    25565
    24454
  ];
}