{ config, options, pkgs, lib, globals, ... }:

let
  cfg = config.networking.sshForwarding;
  portFormat = _: {
    options = with lib; {
      address = mkOption {
        description = "The host to bind to";
        type = with types; nullOr str;
        default = null;
      };
      port = mkOption {
        description = "The host port to expose";
        type = with types; nullOr port;
        default = null;
      };
    };
  };
  bindFormat = _: {
    options = with lib; {
      type = mkOption {
        description = "Type of binding";
        type = with types; enum [
          "port"
          "socket"
        ];
        default = "port";
      };
      forwardPort = mkOption {
        description = "The host to bind to";
        type = with types; nullOr (coercedTo port (port: { inherit port; }) (submodule portFormat));
        default = null;
      };
      forwardSocket = mkOption {
        description = "The socket to bind to";
        type = with types; nullOr str;
        default = null;
      };
    };
  };
  subMod = _: {
    options = with lib; {
      
      host = mkOption {
        type = with types; (coercedTo port (port: {
          forwardPort = {
            address = "127.0.0.1";
            inherit port;
          };
          type = "port";
        }) (submodule bindFormat));
      };
      remote = mkOption {
        type = with types; (coercedTo port (port: {
          forwardPort = {
            inherit port;
          };
          type = "port";
        }) (submodule bindFormat));
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
      type = with types; listOf (coercedTo port (host: { inherit host; remote = host; }) (submodule subMod));
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
          "-R ${
            if (x.remote.type == "port") then (
              if (x.remote.forwardPort.address != null) then (
                x.remote.forwardPort.address + ":" + (toString x.remote.forwardPort.port)
              ) else (
                toString x.remote.forwardPort.port
              )
            ) else (
              x.remote.forwardSocket
            )
          }:${
            if (x.host.type == "port") then (
              x.host.forwardPort.address + ":" + (toString x.host.forwardPort.port)
            ) else (
              x.remote.forwardSocket
            )
          }"
        );
      in ''
        ${pkgs.openssh}/bin/ssh \
          -NTC \
          -vvv \
          -i /nix/host/keys/ssh-tunnel/id.key \
          -oStrictHostKeyChecking=yes \
          -o UserKnownHostsFile=${toString (pkgs.writeTextFile {
            name = "known_hosts";
            text = lib.concatStringsSep "\n" cfg.trustedHostKeys;
          })} \
          -o ServerAliveInterval=60 \
          -o ExitOnForwardFailure=yes \
          ${lib.concatStringsSep " " portArgs} \
          ${cfg.proxyUser}@${globals.vps.get} \
          -p ${toString cfg.sshPort}
      '';
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  });
}