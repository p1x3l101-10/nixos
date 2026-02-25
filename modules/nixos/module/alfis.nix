{ config, options, lib, pkgs, ... }:

let
  cfg = config.networking.alfis;
  inherit (lib) mkOption mkEnableOption mkIf types mkMerge;
in {
  options.networking.alfis = {
    enable = mkEnableOption "alfis";
    package = mkOption {
      description = "Alfis package to use. If you want a gui, change to pkgs.alfis";
      type = types.package;
      default = pkgs.alfis-nogui;
      example = pkgs.alfis;
    };
    integrations = let
      mkDescription = name: "Whether to hook into ${name} for name resolution";
    in {
      resolved = mkOption {
        description = mkDescription "systemd-resolved";
        type = types.enum [
          "off"
          "fallback"
          "primary"
        ];
        default = "primary";
      };
      networkmanager = mkOption {
        description = mkDescription "Network Manager";
        type = types.enum [
          "off"
          "prepend"
          "append"
        ];
        default = "prepend";
      };
    };
    # This attrset was pulled from the generated config on 02/24/2026
    settings = {
      origin = mkOption {
        description = "The hash of the first block in a chain to know with which nodes to work";
        default = "0000001D2A77D63477172678502E51DE7F346061FF7EB188A2445ECA3FC0780E";
        type = types.str;
      };
      key_files = mkOption {
        description = "Paths to your key files to load automatically";
        type = with types; listOf path;
        default = [];
        example = [
          "/var/lib/keys/key1.toml"
          "/var/lib/keys/key2.toml"
        ];
      };
      check_blocks = mkOption {
        description = "How many last blocks to check on start";
        type = types.ints.u16;
        default = 8;
      };
      net = {
        peers = mkOption {
          description = "All bootstrap nodes";
          type = with types; listOf str;
          default = [
            "peer-v4.alfis.name:4244"
            "peer-v6.alfis.name:4244"
            "peer-ygg.alfis.name:4244"
          ];
        };
        listen = mkOption {
          description = "Your node will listen on that address for other nodes to connect";
          type = types.str;
          default = "[::]:4244";
        };
        public = mkOption {
          description = "Set true if you want your IP to participate in peer-exchange, or false otherwise";
          type = types.bool;
          default = true;
        };
        yggdrasil_only = mkOption {
          description = "Allow connections to/from Yggdrasil only (https://yggdrasil-network.github.io)";
          type = types.bool;
          default = false;
        };
      };
      dns = {
        listen = mkOption {
          description = "Your DNS resolver will be listening on this address and port (Usual port is 53)";
          type = types.str;
          default = "127.0.0.3:53";
        };
        threads = mkOption {
          description = "How many threads to spawn by DNS server";
          type = types.ints.u16;
          default = 10;
        };
        forwarders = mkOption {
          description = "Servers to forward DNS Queries to";
          type = with types; listOf str;
          default = [];
          example = [
            # AdGuard DNS servers to filter ads and trackers
            "https://dns.adguard.com/dns-query"
            "94.140.14.14:53" "94.140.15.15:53"
            # Cloudflare servers
            "https://cloudflare-dns.com/dns-query"
            "1.1.1.1:53" "1.0.0.1:53"
          ];
        };
        bootstraps = mkOption {
          description = "Bootstrap DNS-servers to resolve domains of DoH providers";
          type = with types; listOf str;
          default = [
            "9.9.9.9:53"
            "94.140.14.14:53"
          ];
        };
        enable_0x20 = mkOption {
          description = "Enable DNS 0x20 encoding for cache poisoning protection";
          type = types.bool;
          default = true;
        };
        hosts = mkOption {
          description = "Hosts file support (resolve local names or block ads)";
          type = with types; listOf str;
          default = [];
          example = [
            "system"
            "adblock.txt"
          ];
        };
      };
      mining = {
        threads = mkOption {
          description = "How many CPU threads to spawn for mining, zero = number of CPU cores";
          type = types.ints.u16;
          default = 0;
        };
        lower = mkOption {
          description = "Set a lower priority for mining threads";
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      users = {
        users.alfis = {
          isSystemUser = true;
          group = "alfis";
          description = "alfis user";
          home = "/var/lib/alfis";
          createHome = false;
        };
        groups.alfis = {};
      };
      systemd = {
        services = {
          alfis = {
            description = "alfis";
            wants = [ "networking.target" ];
            after = [ "networking.target" ];
            wantedBy = [ "multi-user.target" ];
            reload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
            reloadIfChanged = true;
            serviceConfig = {
              User = "alfis";
              Group = "alfis";
              ProtectHome = true;
              ProtectSystem = true;
              SecureBits = "keep-caps";
              CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
              AmbientCapabilities = "CAP_NET_BIND_SERVICE";
              SyslogIdentifier = "alfis";
              WorkingDirectory = "/var/lib/alfis";
              ExecStart = let
                configFile = (pkgs.formats.toml { }).generate "alfis.conf" cfg.settings;
              in "${cfg.package}/bin/alfis -n -c ${configFile}";
              Restart = "always";
              TimeoutStopSec = 5;
            };
          };
        };
        tmpfiles.settings."10-alfis"."/var/lib/alfis".d = {
          user = "alfis";
          group = "alfis";
          mode = "0700";
        };
      };
      networking.nameservers = [
        cfg.settings.dns.listen
      ];
    }
    (mkIf (cfg.integrations.resolved != "off") {
      services.resolved.settings.Resolve.DNS = mkIf (cfg.integrations.resolved == "primary") [
        cfg.settings.dns.listen
      ];
      services.resolved.settings.Resolve.FallbackDNS = mkIf (cfg.integrations.resolved == "fallback") [
        cfg.settings.dns.listen
      ];
    })
    (mkIf (cfg.integrations.networkmanager != "off") {
      networking.networkmanager.appendNameservers = (cfg.integrations.networkmanager == "append") [
        cfg.settings.dns.listen
      ];
      networking.networkmanager.insertNameservers = (cfg.integrations.networkmanager == "prepend") [
        cfg.settings.dns.listen
      ];
    })
  ]);
}
