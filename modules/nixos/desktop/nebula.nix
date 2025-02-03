{ config, ... }:
let
  keyPath = "/nix/host/keys/nebula/";
  HN = config.networking.hostName;
in
{
  services.nebula.networks.cosmic = {
    firewall = {
      inbound = [ ];
      outbound = [ ];
    };

    enable = false; # Not ready
    ca = keyPath + "ca.crt";
    key = keyPath + HN + ".key";
    cert = keyPath + HN + ".crt";
    lighthouses = [
      "192.168.100.1"
    ];
    staticHostMap = {
      "192.168.100.1" = [ "192.168.42.6:4242" ];
    };
  };
}
