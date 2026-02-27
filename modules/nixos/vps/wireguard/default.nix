{ config, globals, ... }:

let
  keydir = "${globals.dirs.keys}/wireguard";
  wg = globals.wireguard;
in {
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = config.systemd.network.networks."10-wan".name;
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard = {
    enable = true;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      # Allow forwarding
      networkConfig = {
        # do not use IPMasquerade,
        # unnecessary, causes problems with host ipv6
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
      routingPolicyRules = [
        {
          Family = "both";
          DestinationPort = 2222;
        }
      ];
    };
    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = "${keydir}/wg.key";
        RouteTable = wg.table;
        FirewallMark = wg.firewallMark;
      };
      wireguardPeers = [
        {
          PublicKey = "5QTA4QV0CpNiTWpbKXGHjyszU48e2xfhBwdiH9B0Aic=";
          AllowedIPs = [
            # Server internal IP
            "10.64.186.60/32"
            "fd31:8b54:ccba::ccba/64"
          ];
        }
      ];
    };
  };
  # Ensure the keys are readable by the correct users
  systemd.tmpfiles.settings."10-wireguard-keys"."${keydir}".Z = {
    mode = "0750";
    user = "systemd-network";
    group = "systemd-network";
  };
}
