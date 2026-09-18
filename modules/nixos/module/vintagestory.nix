{ config, options, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.services.vintageStory;
in {
  options.services.vintageStory = {
    enable = mkEnableOption "Vintage Story Dedicated Server";
    package = mkOption {
      default = pkgs.vintagestory;
      type = types.package;
    };
    openFirewall = mkEnableOption "Open the firewall";
    settings = {
      config = mkOption {
        description = "Config to be passed to server";
        default = {};
        type = types.attrs;
      };
    };
  };
  config = mkIf (cfg.enable) {
    systemd.services.vintageStory = {
      confinement = {
        enable = false;
        fullUnit = true;
        packages = [
          cfg.package
        ];
      };
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];
      unitConfig = {
        ExecStart = builtins.concatStringsSep " " [
          "${cfg.package}/bin/vintagestory-server"
          "--setconfig=${builtins.toJSON cfg.settings.config}"
          "--dataPath=/var/lib/vintageStory"
        ];
      };
    };
    systemd.tmpfiles.settings."50-vintageStory" = {
      "/var/lib/vintageStory".d = {
        user = "vintageStory";
        group = "vintageStory";
        mode = "0755";
      };
      "/var/lib/vintageStory/data".d = {
        user = "vintageStory";
        group = "vintageStory";
        mode = "0755";
      };
    };
    users = {
      users.vintageStory = {
        createHome = false;
        home = "/var/lib/vintageStory";
        isSystemUser = true;
      };
      groups.vintageStory.members = [ "vintageStory" ];
    };
  };
}
