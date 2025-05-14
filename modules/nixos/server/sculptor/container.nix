{ ... }:

{
  imports = [
    # Modules needed
    ../../module/default.nix
    # Container
    ./nginx.nix
    ./sculptor.nix
  ];
  networking.firewall.enable = true;
  system.stateVersion = "24.11";
}