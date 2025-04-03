{ lib, ... }:

let
  base = ../../modules/nixos/base;
in
{
  imports = [
    "${base}/cachix.nix"
    "${base}/locale.nix"
    "${base}/ssh.nix"
  ];
  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    useNetworkd = true;
    usePredictableInterfaceNames = true;
  };
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks = {
      "10-virtual-eth" = {
        name = "eth0";
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
  programs.nano.enable = lib.mkDefault false;
  system.stateVersion = "24.11";
}