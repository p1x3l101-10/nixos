{ pkgs, lib, ext, ... }:

let
  hyprLib = import ../../../home/desktop/hyprland/support/hypr-lib.nix { inherit lib ext; };
  hyprGlobals = import ../../../home/desktop/hyprland/support/hypr-globals.nix { inherit pkgs lib ext hyprLib; };
  inherit (hyprGlobals) clockFormat;
in

lib.fix (self: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  services.udisks2.enable = true;
  programs.uwsm.enable = true;
  services.gvfs.enable = true;
  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;
  # Autologin on boot
  services.getty = {
    autologinOnce = true;
    autologinUser = "pixel";
  };
})
