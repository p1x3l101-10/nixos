{ pkgs, lib, ext, ... }:

let
  hyprPkgs = ext.inputs.hyprland.packages.${ext.system};
in lib.fix (self: {
  programs.hyprland = {
    enable = true;
    package = hyprPkgs.hyprland;
    portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal.enable = true;
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
