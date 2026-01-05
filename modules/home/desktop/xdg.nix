{ pkgs, lib, ... }:

let
  hypr-globals = import ./hyprland/support/hypr-globals.nix pkgs lib;
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
