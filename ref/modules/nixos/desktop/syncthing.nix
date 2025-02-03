{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "pixel";
    dataDir = "/home/pixel";
    configDir = "/home/pixel/.config/syncthing";
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
