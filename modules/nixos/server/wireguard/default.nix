{ globals, ... }:

let
  keydir = "${globals.dirs.keys}/wireguard";
  addrFamily = "32";
in {
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.useNetworkd = true;

  systemd.network = {
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        # This is a proxy, I want everything through here
        "0.0.0.0/0"
        "::/0"
      ];
      routingPolicyRules = [
        # Redirect Traffic
        {
          # Apply to ipv4 and ipv6
          Family = "both";
          # For all packets marked with 42
          InvertRule = false;
          FirewallMark = 42;
          # Specify that the wireguard's routing table must be used
          Table = 1000;
          # Set priority to allow overriding
          Priority = 10;
        }
        # Exclude local packets
        {
          To = "192.168.0.0/24";
          Priority = 9;
        }
        # Exclude endpoint IP
        {
          To = "${globals.vps.ip}/${addrFamily}";
          Priority = 5;
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
        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = "${keydir}/wg.key";
        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = 1000;
        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = "MG1l9Y/+lxfhtDQtfq/QepzQYCyiFEEPyRuNZq7mUiM=";
          AllowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          Endpoint = "${globals.vps.ip}:51820";
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
  # NixOS firewall will block wg traffic because of rpfilter
  networking.firewall.checkReversePath = "loose";
}
