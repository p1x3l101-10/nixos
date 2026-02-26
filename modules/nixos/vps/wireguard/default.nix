{ config, globals, ... }:

let
  keydir = "${globals.dirs.keys}/wireguard";
in {
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = config.systemd.network.networks."10-wired".name;
    internalInterfaces = [ "wg0" ];
  };

  systemd.network = {
    enable = true;
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        "0.0.0.0/0"
        "::/0"
      ];
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
        RouteTable = 1000;
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = "5QTA4QV0CpNiTWpbKXGHjyszU48e2xfhBwdiH9B0Aic=";
          AllowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };
  };
  # Ensure the keys are readable by the correct users
  systemd.tmpfiles.settings."10-wireguard-keys"."${keydir}".Z = {
    mode = "0750";
    owner = "systemd-network";
    group = "systemd-network";
  };
}
