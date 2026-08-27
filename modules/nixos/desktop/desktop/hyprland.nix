{ lib, ext, ... }:

let
  hyprPkgs = (builtins.getFlake "github:NixOS/nixpkgs/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5?narHash=sha256-dN6Ou5x").packages."${ext.system}";
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
