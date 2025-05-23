{ config, lib, ... }:

lib.mkIf (config.networking.hostName == "pixels-pc") {
  networking.firewall = {
    allowedUDPPorts = [ 9757 ];
    allowedTCPPorts = [ 5353 9757 ];
  };
}