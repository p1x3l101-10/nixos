{ pkgs, lib, ext, config, ... }:

let
  inherit (import ../hyprland/support/hypr-globals.nix { inherit pkgs lib ext; }) clockFormat;
  inherit (config.lib.stylix) colors;
  inherit (config.stylix) fonts opacity;
in {
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = import ./ashell.config.nix { inherit clockFormat colors fonts opacity; };
  };
  stylix.targets.ashell.enable = false;
  systemd.user.services.ashell.Unit.X-Restart-Triggers = [ "${config.xdg.configHome}/ashell/config.toml" ];
}
