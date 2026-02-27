{ lib, ... }:

{
  systemd.network.networks."10-wired" = {
    name = "enp2s0";
    DHCP = "yes";
    linkConfig.RequiredForOnline = "routable";
  };
}
