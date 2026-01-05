{ pkgs, lib, ... }:

let
  hyprLib = lib.extend (final: prev: { hypr = import ./hyprland/support/hypr-lib.nix lib });
  hypr-globals = import ./hyprland/support/hypr-globals.nix pkgs hyprLib;
in {
  xdg = {
    userDirs.enable = true;
    terminal-exec = {
      enable = true;
      settings = {
        "start-hyprland:Hyprland" = [
          (hypr-globals.apps.terminal.desktop)
        ];
      };
    };
  };
}
