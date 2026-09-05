{ pkgs, lib, ext, ... }:

let
  hypr-globals = import ./hyprland/support/hypr-globals.nix { inherit pkgs lib ext; };
in {
  xdg = {
    userDirs = {
      enable = true;
      setSessionVariables = true;
    };
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
