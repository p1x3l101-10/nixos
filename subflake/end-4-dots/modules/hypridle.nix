{ config, lib, ... }:
let
  enabled = config.illogical-impulse.enable;
in
{
  config = lib.mkIf enabled {
    services.hypridle = {
      enable = true;
      settings = {        
        general = {
          lock_cmd = "pidof hyprlock || hyprlock-background";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 180;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 240;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 540;
            on-timeout = "pidof steam || systemctl suspend || loginctl suspend";
          }
        ];
      };
    };
  };
}