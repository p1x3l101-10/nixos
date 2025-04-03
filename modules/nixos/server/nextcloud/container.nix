{ ... }:

{
  imports = [
    ./apps.nix
    #./caching.nix
    ./mail.nix
    ./network.nix
    ./nextcloud.nix
    #./s3.nix
    ./secrets.nix
    #./ssl.nix # No domain at the moment
  ];
  networking.firewall.enable = true;
  system.stateVersion = "24.11";
}