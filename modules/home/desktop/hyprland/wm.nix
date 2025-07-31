{ ext, pkgs, lib, ... }:
let
  inherit (ext) inputs system;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Nixos manages these packages
    package = null;
    portalPackage = null;
    plugins = (with inputs.hyprland-plugins.packages.${system}; []);
    settings = import ./support/hyprland-config.nix lib;
    systemd.enable = true;
    xwayland.enable = true;
  };
}