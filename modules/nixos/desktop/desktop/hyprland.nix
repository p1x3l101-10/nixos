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
    cageArgs = [
      "-s" # DO NOT REMOVE, IT WILL LOCK YOU INTO CAGE WITHOUT THIS
      "-d" # No decorations
      "-m" "last" # Display on last connected screen
    ];
  };
  systemd.tmpfiles.settings."99-regreet-defaults" = {
    "/var/lib/regreet/state.toml".C = {
      user = "greeter";
      group = "greeter";
      mode = "0644";
      argument = builtins.toString ((pkgs.formats.toml { }).generate "state.toml" {
        last_user = "pixel";
        user_to_last_sess.pixel = "Hyprland (uwsm-managed)";
      });
    };
  };
})
