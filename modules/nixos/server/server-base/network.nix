{ lib, ... }:

{
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks = {
      "10-wired" = {
        name = "enp2s0";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    llmnr = "true";
    dnsovertls = "true";
  };
  # Disable alterantives
  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    useNetworkd = true;
  };
}
