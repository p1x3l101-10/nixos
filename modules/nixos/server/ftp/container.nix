{ ... }:

{
  imports = [
    ./ftp.nix
    ./network.nix
    ./users.nix
  ];
  networking.firewall.enable = true;
  system.stateVersion = "24.11";
}
