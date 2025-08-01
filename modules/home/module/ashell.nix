{ options, config, lib, pkgs, ... }:

let
  cfg = config.programs.ashell;
  inherit (lib) mkOption mkEnableOption mkIf types;
in {
  options.programs.ashell = {
    enable = mkEnableOption "ashell";
    package = mkOption {
      description = "ashell package";
      type = types.package;
      default = pkgs.ashell;
    };
    settings = mkOption {
      description = "Setting for ashell";
      type = types.attrs;
      default = {};
    };
    systemd = {
      enable = mkEnableOption "systemd integration";
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."ashell/config.toml".source = (pkgs.formats.toml { }).generate "ashell-config" cfg.settings;
    systemd.user.services = mkIf cfg.systemd.enable {
      ashell = {
        Unit = {
          Description = "Hyprland shell";
        };
        Service = {
          ExecStart = "${pkgs.ashell}/bin/ashell";
        };
        Install.WantedBy = [ "hyprland-session.target" ];
      };
    };
  };
}
