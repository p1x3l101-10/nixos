{ lib, ... }:

{
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks = {
      "40-eth0" = {
        name = "eth0";
        linkConfig.RequiredForOnline = "routable";
        gateway = [ "10.10.10.1" ];
        address = [ "10.10.10.4/24" ];
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
  networking = {
    firewall.allowedTCPPorts = [ 9000 ];
    # Disable alterantives
    dhcpcd.enable = false;
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    useNetworkd = true;
    useHostResolvConf = lib.mkForce false;
  };
}