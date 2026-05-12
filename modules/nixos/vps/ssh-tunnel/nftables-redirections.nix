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
  cfg = config.networking.portRedirections;
in {
  options = with lib; {
    networking.portRedirections = mkOption {
      description = "Port redirections";
      default = [];
      type = with lib.types; listOf (submodule portPair);
    };
  };
  config = lib.mkIf (cfg != []) {
    networking.firewall.extraCommands = builtins.concatStringsSep "\n" (map
      (x: "iptables -I nixos-fw -A PREROUTING -t nat -p tcp --dport ${builtins.toString x.sourcePort} -j REDIRECT --to-port ${builtins.toString x.sinkPort}")
      cfg
    );
    # SSH only forwards TCP connections
    networking.firewall.allowedTCPPorts = (map
      (x: x.sourcePort)
      cfg
    );
  };
}
