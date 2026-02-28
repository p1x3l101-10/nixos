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
  networking.wireless.iwd = {
    enable = true;
    encryptDB.enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = false; # NetworkD is handling that instead.
        AddressRandomization = "network";
        AddressRandomizationRange = "full";
        SystemdEncrypt = "iwd-secret";
        Country = "us";
      };
    };
  };
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/iwd"
  ];
}
