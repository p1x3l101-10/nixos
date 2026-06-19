{ globals, ... }:

{
  systemd.network.networks = {
    "10-wired" = {
      name = "enp*";
      DHCP = "yes";
      linkConfig.RequiredForOnline = "routable";
    };
    "10-wireless" = {
      name = "wlp1s0";
      DHCP = "yes";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.wireless.interfaces = [ "wlp1s0" ];
}
