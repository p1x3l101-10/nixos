{ config, lib, ... }:

let
  portPair = _: with lib; {
    options = {
      sourcePort = mkOption {
        description = "Port to listen on";
        type = types.port;
      };
      sinkPort = mkOption {
        description = "Port that will be listened on by other services";
        type = types.port;
      };
    };
  };
  cfg = config.networking.nftables.portRedirections;
in {
  options = with lib; {
    networking.nftables.portRedirections = mkOption {
      description = "Port redirections";
      default = [];
      type = with lib.types; listOf (submodule portPair);
    };
  };
  config = lib.mkIf (cfg != []) {
    networking.nftables.ruleset = builtins.concatStringsSep "\n" (map
      (x:
        ''
          table nat {
            chain prerouting {
              type nat hook prerouting priority 0;
              tcp dport ${builtins.toString x.sourcePort} dnat :${builtins.toString x.sinkPort}
            }
          }
        ''
      )
      cfg
    );
    # SSH only forwards TCP connections
    networking.firewall.allowedTCPPorts = (map
      (x: x.sourcePort)
      cfg
    );
  };
}
