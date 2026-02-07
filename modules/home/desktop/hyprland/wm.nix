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
    settings = import ./support/hyprland-config.nix pkgs lib;
    systemd.enable = true;
    xwayland.enable = true;
  };
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    gtk3 # Desktop file runner
  ];
}
