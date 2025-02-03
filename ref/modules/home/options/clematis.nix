{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.clematis;
in
{
  options.services.clematis = {
    enable = mkEnableOption "Clematis";
    package = mkPackageOption pkgs "clematis" { };
    enableConfig = mkEnableOption "custom config";

    config = {
      vars = mkOption {
        type = types.listOf types.str;
        description = "define a list of vars for the presence from the metadata";
        default = [ ];
      };
      whitelist = mkOption {
        type = types.listOf types.str;
        description = "list of whitelisted clients";
        default = [ ];
        example = [ "ncspot" ];
      };
      blacklist = mkOption {
        type = types.listOf types.str;
        description = "list of blacklisted clients";
        default = [ ];
        example = [ "firefox" ];
      };
      useIdentifiers = mkEnableOption "player identifiers instead of names";
      logLevel = mkOption {
        type = types.str;
        description = "level for log";
        default = "info";
        example = "info || debug || error";
      };

      presence = {
        details = mkOption {
          type = types.str;
          description = "the top text in the presence";
          default = "{title}";
          example = "Playing {title}";
        };
        state = mkOption {
          type = types.str;
          description = "the bottom text in the presence";
          default = "{artist} {album}";
          example = "";
        };
      };

      playerPresence = mkOption {
        default = { };
        type = types.submodule;
        description = "define unique presence data per player";
        example = {
          ncspot = {
            details = "{title}";
            state = "{artist} {album}";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    systemd.user.services.clematis = {
      Unit = {
        Description = "Discord MPRIS Rich Presence";
        Requires = [ "graphical-session.target" ];
      };
      Service.ExecStart = "${cfg.package}/bin/clematis";
    };
    xdg.configFile."Clematis/config.json" = {
      text = builtins.toJSON cfg.config;
      enable = cfg.enableConfig;
    };
  };
}
