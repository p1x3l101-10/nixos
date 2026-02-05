{ pkgs, lib, config, ... }:

let
  globals = import ./support/hypr-globals.nix pkgs lib;
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # Ensure we dont accidentally start 2 or more lockscreens
        unlock_cmd = "pkill -USR1 hyprlock";
        before_sleep_cmd = "";
        after_sleep_cmd = "";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          # Darken if possible
          timeout = 150; # 2.5 min
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        /*
        {
          # Lock screen after idling for too long
          timeout = 300; # 5 min
          on-timeout = globals.lockCmd;
        }
        */
        {
          # Blank screen
          timeout = 330; # 5.5 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
