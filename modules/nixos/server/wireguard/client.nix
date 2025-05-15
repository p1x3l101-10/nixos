{ ... }:

{
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;
      privateKeyFile = "/nix/host/keys/wireguard/psk";
      peers = [
        {
          publicKey = "ucgK70UvjSTHb534wxkkGzAuuSeqmjzq81nMw5F64A0";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "piplup.pp.ua:51820";
          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}