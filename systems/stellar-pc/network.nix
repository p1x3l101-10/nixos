{ globals, ... }:

{
  systemd.network.networks = {
    "10-wired" = {
      name = "enp8s0";
      DHCP = "yes";
      linkConfig.RequiredForOnline = "routable";
    };
    "10-wireless" = {
      name = "wlp6s0";
      DHCP = "yes";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.wireless.interfaces = [ "wlp6s0" ];
}
