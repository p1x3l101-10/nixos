{ config, pkgs, lib, ... }:

{
  services.yggdrasil = {
    enable = true;
    group = "wheel";
    persistentKeys = true;
    denyDhcpcdInterfaces = [ "tap*" ];
    settings = {
      Peers = [
        # Public peers
        # NOTE: these peers are taken from this list "https://publicpeers.neilalexander.dev/"
        # Dont oversaturate it.
        "tls://ygg.jjolly.dev:3443"
        "quic://ygg4.mk16.de:1339?key=000000573433e11f23768b078bcdc10b42712a7b131d6d04b82042ffc0c97df0"
        "tls://longseason.1200bps.xyz:13122"
        "tls://ygg.mnpnk.com:443"
        # Less public peers
        # NOTE: I can do a total free for all here if I want
      ];
      Listen = [];
      MulticastInterfaces = [
        {
          Regex = "en.*";
          Beacon = true;
          Listen = true;
          Password = "";
        }
        {
          Regex = "bridge.*";
          Beacon = true;
          Listen = true;
          Password = "";
        }
        {
          Regex = "awdl0";
          Beacon = false;
          Listen = false;
          Password = "";
        }
      ];
      AllowedPublicKeys = [];
      IfName = "auto";
      IfMTU = 65535;
      NodeInfoPrivacy = false;
      NodeInfo = {};
    };
  };
  # It puts the keys in the incorrect location
  systemd.services.yggdrasil-persistent-keys = let
    keysPath = "/var/lib/private/yggdrasil"; # The notable part
    binYggdrasil = "${config.services.yggdrasil.package}/bin/yggdrasil";
  in {
    script = lib.mkForce ''
      if [ ! -e ${keysPath} ]
      then
        mkdir --mode=700 -p ${dirOf keysPath}
        ${binYggdrasil} -genconf -json \
          | ${pkgs.jq}/bin/jq \
              'to_entries|map(select(.key|endswith("Key")))|from_entries' \
          > ${keysPath}
      fi
    '';
  };
  networking.alfis = {
    enable = true;
    integrations = {
      resolved = "fallback";
      networkmanager = "append";
      resolvconf = false;
    };
  };
  # Setting one NS breaks everything
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  environment.persistence."/nix/host/state/Yggdrasil".directories = [
    "/var/lib/private/yggdrasil"
    { directory = "/var/lib/alfis"; user = "alfis"; group = "alfis"; mode = "0700"; }
  ];
}
