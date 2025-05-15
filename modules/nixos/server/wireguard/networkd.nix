{ config, lib, pkgs, ... }:

let
  wgFwMark = 4242;
  wgTable = 1000;
  wgEndpoint = "piplup.pp.ua:51820";
in {
  systemd.network = {
    netdevs = {
      "99-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/nix/host/keys/wireguard/psk";
          ListenPort = 9918;
          FirewallMark = wgFwMark;
        };
        wireguardPeers = [
          {
            PublicKey = "ucgK70UvjSTHb534wxkkGzAuuSeqmjzq81nMw5F64A0=";
            AllowedIPs = [
              "0.0.0.0/0"
            ];
            Endpoint = wgEndpoint;
          }
        ];
      };
    };
    networks = {
      "99-wg0" = {
        matchConfig.Name = "wg0";
        address = [
          "fe80::3/64"
          "fc00::3/120"
          "10.100.0.2/24"
        ];
        DHCP = "no";
        dns = ["fc00::53"];
        ntp = ["fc00::123"];
        gateway = [
          "fc00::1"
          "10.100.0.1"
        ];
        networkConfig = {
          IPv6AcceptRA = false;
        };
      };
      "99-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig = {
          Address = "172.22.1.6/22";
          DNS = "192.168.1.2";
          DNSDefaultRoute = true; # make wireguard tunnel the default route for all DNS requests?
          Domains = "~."; # default DNS route for all domains?
        };
        routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            InvertRule = true;
            FirewallMark = wgFwMark;
            Table = wgTable;
            Priority = 10;
          };
        }
      ];
      routes = [
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            Table = wgTable;
          };
        }
      ];
      linkConfig = {
        ActivationPolicy = "manual"; # manually turn on/off wireguard tunnel with networkctl instead of automatically at boot
        RequiredForOnline = "no";
      };
    };
  };
}