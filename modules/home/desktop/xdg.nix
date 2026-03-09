{ pkgs, lib, ext, ... }:

let
  hyprLib = import ./hyprland/support/hypr-lib.nix { inherit lib ext; };
  hypr-globals = import ./hyprland/support/hypr-globals.nix { inherit pkgs lib ext hyprLib; };
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
