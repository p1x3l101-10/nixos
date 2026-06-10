{ config, lib, pkgs, ... }:

let
  cfg = config.services.dontStarveTogether;
  inherit (lib) mkIf;
in {
  options.services.dontStarveTogether = (
    let
      inherit (lib) mkOption mkEnableOption types;
    in {
      enable = mkEnableOption "Don't Starve Together Dedicated Server";
      package = mkOption {
        description = "Server depot package to use";
        type = types.package;
        default = pkgs.internal.dst-server;
      };
    }
  );
  config = mkIf cfg.enable {
  };
}
