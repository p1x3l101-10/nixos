{ lib, ext, ... }:

let
  hyprPkgs = ext.hyprPin.pkgs;
in

lib.fix (self: {
  programs.hyprland = {
    enable = true;
    package = hyprPkgs.hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with hyprPkgs; [ xdg-desktop-portal-hyprland ];
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
