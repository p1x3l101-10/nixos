{ pkgs, lib, ext, ... }:

let
  inherit (import ../hyprland/support/hypr-globals.nix { inherit pkgs lib ext; }) clockFormat;
in {
  programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = import ./ashell.config.nix { inherit clockFormat; };
  };
}
