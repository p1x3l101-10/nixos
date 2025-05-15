{ pkgs, ... }:

{
  # Host config to help with running containers
  boot = {
    enableContainers = true;
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" "vb-+" "br0" ];
      externalInterface = "enp2s0";
      enableIPv6 = true;
    };
    bridges.br0.interfaces = [
      "eth0"
    ];
    interfaces.host0.ipv4.addresses = [{
      address = "10.10.10.1";
      prefixLength = 24;
    }];
  };
  environment.persistence."/nix/host/cache".directories = [
    { directory = "/var/lib/machines"; mode = "0700"; }
    { directory = "/var/lib/containers"; mode = "0700"; }
  ];
}
