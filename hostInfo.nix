{ lib, ext, ... }:

lib.fix (final: let
  mkAddrs = definedAddrs: (
    {
      __functor = addrs: namespace: (
        if (builtins.hasAttr namespace addrs) then {
          v4 = if (builtins.hasAttr "v4" addrs."${namespace}") then addrs."${namespace}".v4 else null;
          v6 = if (builtins.hasAttr "v6" addrs."${namespace}") then addrs."${namespace}".v6 else null;
        } else {
          v4 = null;
          v6 = null;
        }
      );
    } // definedAddrs
  );
  mkManagedSsh = (
    { host
    , portType ? "default"
    , keyType ? "default"
    }:
    let
      defaultSshPort = 22;
      hostAttrs = final.hosts."${host}";
    in {
      name = (
        if (hostAttrs.ssh.port."${portType}" == defaultSshPort) then (
          hostAttrs.fqdn
        ) else (
          "[${hostAttrs.fqdn}]:${hostAttrs.ssh.port."${portType}"}"
        )
      );
      value = [ hostAttrs.ssh.keys."${keyType}" ];
    }
  );
in {
  globals = {
    domain = {
      default = final.globals.domain.main;
      main = "exsmachina.org";
    };
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
    ssh.knownHosts = ext.lib.attrsets.mergeAttrs [
      {
        "github.com" = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk="
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
        ];
        "livingroom-bigscreen.local" = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1McDei2vX4WFrWQu15CUCMcs6pxtpquRlyOFw1CLFz"
        ];
        "musicass.local" = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7uavSro0+hgxHLihAruEFQIpha99/khxy/Nft1MHkN"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYkk+T+Hpld7Q2qtGgO9+qX9+p56BUTwNzhOs67tutUCdYf5jRvdyP2nxIKcszpkIYFMrgJ1pJ8eoA9VKQmNdbB9WFYmXQWunVIgXmSxweufBAbmTy82duXJwW7JBS1D+o2BigRKHYPjlE29Wharl6jkjT64XSxscnS01dmfgW4qY3yx0OUnnIUDTQn+x1Kfwpq/PtoOZDhq1aLVt5gRc9Qc4LiI1qzwnVMgW6DQGJ2rf/MtDOc3CSkdWksE/ym0wPEMIYvqz6TGJJzrLhtBer7oNE7a/XpiV0Gi9se5+d9lnjGu8I5jQPDWyALFndIxA13nSUDClvPyUGh9ipqEyY4Agh4fcsdB2M34579E1IX/LDn+wPLgZk5+0d6HAD0Wwh0sxe0kJEBmZB28aBCvj+hnLgHrzHHYFBP0LBamuTxuQxUPDav7O6GPxCYn/3FAbWlVgHW/aW2O2A44Efr09o6wEZt3YqlfzUX2EqEfuzqHCeEavu5cXdSa9Q847P6ik="
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH+5kXALI+nK3nvQMH7LbNi3l7G0VZmyl3FM0qHa3n2qRAT7EhCSFZJHE7JLD8ZZ2+2wt8ASV8CEFAzaNiTO4cI="
        ];
        "terminal.shop" = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzsOgEiuiTQEUZnMORRmhMHDSAo8VBUl/g55Ec6ZaKM"
        ];
      }
      (mkManagedSsh { host = "stellar-server"; portType = "clearExternal"; })
      (mkManagedSsh { host = "stellar-pc"; })
      (mkManagedSsh { host = "stellar-laptop"; })
    ];
  };
  hosts = {
    stellar-server = lib.fix (hostFinal: {
      fqdn = "${hostFinal.subdomain}.${final.globals.domain.default}";
      subdomain = "srv02";
      ipAddrs = mkAddrs {
        default = hostFinal.ipAddrs "clearExternal";
        natInternal = {
          v4 = "192.168.42.6";
          v6 = "fe80::96c6:91ff:fef4:6664";
        };
        clearExternal.v4 = "158.62.185.180";
        wireguard = {
          v4 = "10.64.186.60";
          v6 = "fd31:8b54:ccba::ccba";
        };
        yggdrasil.v6 = "200:903a:501d:3ba8:6c58:9aaf:6336:660b";
      };
      ssh = {
        port = {
          default = 22;
          clearExternal = 7003;
        };
        keys = {
          default = hostFinal.ssh.keys.ed25519;
          ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4ggoW9LtZMY/XgVziDDqz7Mh3DB9SMGCCDo5UCDKv0";
        };
      };
      wireguard = {
        pubkey = "5QTA4QV0CpNiTWpbKXGHjyszU48e2xfhBwdiH9B0Aic=";
        port = 51820;
        addrs = hostFinal.ipAddrs.wireguard;
      };
    });
    stellar-pc = lib.fix (hostFinal: {
      fqdn = "stellar-pc.local";
      subdomain = null;
      ipAddrs = mkAddrs {
        default = hostFinal.ipAddrs "natInternal";
        natInternal = {
          v4 = "192.168.1.97";
          v6 = "fe80::40ef:a5b6:c71a:ccbb";
        };
        yggdrasil.v6 = "200:4cd5:987:25f3:c824:a708:9176:3871";
      };
      ssh = {
        port.default = 22;
        keys = {
          default = hostFinal.ssh.keys.rsa;
          rsa = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeoXM0R2b6R3SHk+hg5Jm5V75/OQD0v6p55tuFB6gjBG9ls1yjyaGqRYt7Oktg8QmiDAVuzKP3qV8qbWAqCTJLnSox+pfMOZ0QAPQ2XjQhUnNWMb8Srd9l+a+DRFFJv+9uJuktq/spMjyYn+Nv3bFAMFx5F/Y/NHyfnCQuHkHPnSEB5K5Ug5mbG8AjCDTEsxCeXzOn8iKcOHMftVB5yt/Qx4dNLWxhjWi/KwUNV4pRkQxpf0+5UhYhB3PXRF13a47TEEesiygyFLsOgvhlBky1iKLHqRU4rpcfo5Vy2tONFdbqbrVKrcNIarCB3qVXkG8eWGP/mtSH4IsMNoE4DbByaAE5I8ckIOMe2Qdr/7By3mfOw5SWZMNQOZdJ0b1QeNfnPML9by/IYUaVrK37+vrdqSQlysBwZroPWtGJ5iiSUCgQIzx+mKND2GTiv3kRNhwRNemQiSv3y4NAjezU5y8PvfaZS7Za/3rmBc6pz9mE+K1Cd8W2W4Z+LR0KA/a3/sX1Lr7/ahgoT7/Z64+8mrrTe2sXZsHmzwTOtIyAsQJA3NSTtXQ/GNjA1HDZALqn9Nyl9Zgd+bepV/rN6rJrlzf+q/A/Ik+QpwAXpRbmNksd7hnQXqJyofvi6kj+t+vI8eAZKQBFzQzdwt95snbOrWrWSHtVrw4KvLV4VxDn6wjtlw==";
        };
      };
    });
    stellar-laptop = lib.fix (hostFinal: {
      fqdn = "stellar-laptop.local";
      subdomain = null;
      # Too mobile to tie to a specific natInternal addr
      ipAddrs = mkAddrs {};
      ssh = {
        port.default = 22;
        keys = {
          default = hostFinal.ssh.rsa;
          rsa = "";
        };
      };
    });
  };
})
