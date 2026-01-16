{ pkgs, lib, ... }:

let
  inherit (import ../hyprland/support/hypr-globals.nix pkgs lib) clockFormat
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
