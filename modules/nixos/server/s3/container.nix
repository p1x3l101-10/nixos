{ ... }:

{
  imports = [
    ./minio.nix
    ./network.nix
  ];
  networking.firewall.enable = true;
  system.stateVersion = "24.11";
}