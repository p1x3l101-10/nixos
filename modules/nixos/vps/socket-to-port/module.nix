{ config, options, pkgs, lib, globals, ... }:

let
  cfg = config.services.socket-to-port;
  format = _: {
    options = with lib; {
      socket = mkOption {
        description = "Path to socket";
        type = types.str;
      };
      port = mkOption {
        description = "Port to map to";
        type = types.port;
      };
    };
  };
in

{
  options.services.socket-to-port = with lib; {
    enable = mkEnableOption "Socket mapping";
    sockets = mkOption {
      type = with types; listOf (submodule format);
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.socketMapping = {
      description = "Mapping UNIX sockets to ports";
      after = [ "networking.target" "sshd.service" ];
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
    };
  };
}
