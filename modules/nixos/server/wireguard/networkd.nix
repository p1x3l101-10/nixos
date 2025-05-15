{ config, lib, pkgs, ... }:

{
  systemd.network = {
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/nix/host/keys/wireguard/psk";
          ListenPort = 9918;
        };
        wireguardPeers = [
          {
            PublicKey = "ucgK70UvjSTHb534wxkkGzAuuSeqmjzq81nMw5F64A0=";
            AllowedIPs = ["fc00::1/64" "10.100.0.1"];
            Endpoint = "piplup.pp.ua:51820";
          }
        ];
      };
    };
    networks.wg0 = {
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
  };
}