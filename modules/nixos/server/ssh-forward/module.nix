{ config, options, pkgs, lib, globals, ... }:

let
  cfg = config.networking.sshForwarding;
  portFormat = _: {
    options = with lib; {
      host = mkOption {
        description = "The host port to expose";
        type = types.port;
      };
      remote = mkOption {
        description = "The remote port to listen on";
        type = types.port;
        default = self.config.host;
      };
    };
  };
in {
  options.networking.sshForwarding = with lib; {
    enable = mkEnableOption "ssh forwarding server";
    proxyUser = mkOption {
      type = types.str;
      description = "The user that will accept the connection";
      default = "proxy";
    };
    trustedHostKeys = mkOption {
      description = "The host's public key";
      type = with types; listOf str;
      default = [];
    };
    sshPort = mkOption {
      description = "ssh port to connect to";
      type = types.port;
      default = 22;
    };
    keyFile = mkOption {
      type = types.str;
      description = "The path to the ssh key file to be used";
      default = "";
    };
    ports = mkOption {
      type = with types; listOf (coercedTo port (host: { inherit host; }) (submodule portFormat));
      description = "List of ports to forward";
      default = [];
    };
  };
  config = lib.mkIf cfg.enable (lib.mkIf globals.vps.enabled { # Enable when the module is requested and when the vps exists
    systemd.services.ssh-tunnel = {
      description = "Expose local ports on remote server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
      script = let
        portArgs = lib.forEach cfg.ports (x:
          "-R ${toString x.remote}:127.0.0.1:${toString x.host}"
        );
      in ''
        ${pkgs.openssh}/bin/ssh \
          -NTC \
          -vvv \
          -i /nix/host/keys/ssh-tunnel/id.key \
          -o UserKnownHostsFile=${toString (pkgs.writeTextFile {
            name = "known_hosts";
            text = lib.concatStringsSep "\n" cfg.trustedHostKeys;
          })} \
          -o ServerAliveInterval=60 \
          -o ExitOnForwardFailure=yes \
          ${lib.concatStringsSep " " portArgs} \
          ${cfg.proxyUser}@${globals.vps.get} \
          -p ${cfg.sshPort}
      '';
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  });
}