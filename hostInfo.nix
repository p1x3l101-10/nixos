{ lib, ... }:

lib.fix (final: {
  globals = {
    domain = "exsmachina.org";
    yggdrasil = {
      peers = {
        public = [
          "tls://ygg.jjolly.dev:3443"
          "quic://ygg4.mk16.de:1339?key=000000573433e11f23768b078bcdc10b42712a7b131d6d04b82042ffc0c97df0"
          "tls://longseason.1200bps.xyz:13122"
          "tls://ygg.mnpnk.com:443"
        ];
        private = [];
      };
    };
  };
  hosts = {
    pixels-server = lib.fix (hostFinal: {
      fqdn = "${hostFinal.subdomain}.${final.globals.domain}";
      subdomain = "srv02";
      addrs = {
        internal = {
          v4 = "192.168.42.6";
          v6 = "fe80::96c6:91ff:fef4:6664";
        };
        external = {
          v4 = "166.113.94.187";
          v6 = null;
        };
      };
      ssh = {
        pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4ggoW9LtZMY/XgVziDDqz7Mh3DB9SMGCCDo5UCDKv0";
      };
      wireguard = {
        pubkey = "5QTA4QV0CpNiTWpbKXGHjyszU48e2xfhBwdiH9B0Aic=";
        port = 51820;
        addr = {
          v4 = "10.64.186.60";
          v6 = "fd31:8b54:ccba::ccba";
        };
      };
      yggdrasil = {
        addr = "200:903a:501d:3ba8:6c58:9aaf:6336:660b";
      };
    });
    hetzner-vps = lib.fix (hostFinal: {
      fqdn = "${hostFinal.subdomain}.${final.globals.domain}";
      subdomain = "srv01";
      addrs = {
        internal = {
          v4 = null;
          v6 = null;
        };
        external = {
          v4 = "5.78.134.177";
          v6 = "2a01:4ff:1f0:c947::";
        };
      };
      ssh = {
        pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+JEJ7SczOJCcn/bPGUySPXH0FUsXl8C2/wFY1r3g1h";
      };
      wireguard = {
        pubkey = "4rPW8i34RxX6l2Pql2JuBVVHupPqdbeTtJN0v/o9k0w=";
        port = 51820;
        addr = {
          v4 = "10.64.186.61";
          v6 = "d31:8b54:ccba::acb9";
        };
      };
      yggdrasil = {
        addr = "200:6705:ae87:cdd1:cbff:66c8:a717:663";
      };
    });
    pixels-pc = lib.fix (hostFinal: {
      fqdn = null;
      subdomain = null;
      addrs = {
        internal = {
          v4 = "";
          v6 = "";
        };
        external = {
          v4 = null;
          v6 = null;
        };
      };
      ssh = {
        pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeoXM0R2b6R3SHk+hg5Jm5V75/OQD0v6p55tuFB6gjBG9ls1yjyaGqRYt7Oktg8QmiDAVuzKP3qV8qbWAqCTJLnSox+pfMOZ0QAPQ2XjQhUnNWMb8Srd9l+a+DRFFJv+9uJuktq/spMjyYn+Nv3bFAMFx5F/Y/NHyfnCQuHkHPnSEB5K5Ug5mbG8AjCDTEsxCeXzOn8iKcOHMftVB5yt/Qx4dNLWxhjWi/KwUNV4pRkQxpf0+5UhYhB3PXRF13a47TEEesiygyFLsOgvhlBky1iKLHqRU4rpcfo5Vy2tONFdbqbrVKrcNIarCB3qVXkG8eWGP/mtSH4IsMNoE4DbByaAE5I8ckIOMe2Qdr/7By3mfOw5SWZMNQOZdJ0b1QeNfnPML9by/IYUaVrK37+vrdqSQlysBwZroPWtGJ5iiSUCgQIzx+mKND2GTiv3kRNhwRNemQiSv3y4NAjezU5y8PvfaZS7Za/3rmBc6pz9mE+K1Cd8W2W4Z+LR0KA/a3/sX1Lr7/ahgoT7/Z64+8mrrTe2sXZsHmzwTOtIyAsQJA3NSTtXQ/GNjA1HDZALqn9Nyl9Zgd+bepV/rN6rJrlzf+q/A/Ik+QpwAXpRbmNksd7hnQXqJyofvi6kj+t+vI8eAZKQBFzQzdwt95snbOrWrWSHtVrw4KvLV4VxDn6wjtlw==";
      };
      yggdrasil = {
        addr = "";
      };
    });
  };
})
