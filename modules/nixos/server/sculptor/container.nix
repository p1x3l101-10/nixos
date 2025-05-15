{ ... }:

{
  imports = [
    # Modules needed
    ../../module/default.nix
    # Container
    ./network.nix
    ./nginx.nix
    ./sculptor.nix
  ];
  networking.firewall.enable = false;
  system.stateVersion = "24.11";
}