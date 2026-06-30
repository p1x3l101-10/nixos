{ ext, pkgs, lib, osConfig, ... }:
let
  inherit (ext) inputs system;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Nixos manages these packages
    package = null;
    portalPackage = null;
    configType = "hyprlang";
    settings = import ./support/hyprland-config.nix { inherit pkgs lib ext osConfig; };
    systemd.enable = true;
    xwayland.enable = true;
  };
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    gtk3 # Desktop file runner
  ];
}
