{ pkgs, lib, ext, ... }:

let
  inherit (import ../../../home/desktop/hyprland/support/hypr-globals.nix pkgs lib) clockFormat;
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
  # Greeter
  programs.regreet = {
    enable = true;
    settings = {
      GTK.cursor_blink = true;
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
      widget.clock.format = clockFormat.long;
    };
  };
})
