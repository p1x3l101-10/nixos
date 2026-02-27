{ lib, ... }:

{
  systemd.network.networks."10-wan" = {
    name = "enp1s0";
    linkConfig.RequiredForOnline = "routable";
  };
}
