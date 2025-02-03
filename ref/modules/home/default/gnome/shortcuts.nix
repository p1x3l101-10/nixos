{ config, ... }:
{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      rfkill = [ "<Shift><Super>End" ];
      volume-up = [ "<Shift><Super>Up" ];
      volume-down = [ "<Shift><Super>Down" ];
      next = [ "<Shift><Super>Right" ];
      previous = [ "<Shift><Super>Left" ];
      play = [ "<Super>Pause" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      toggle-fullscreen = [ "<Super>F11" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
    };
    ## Fix conflicts
    # Volume controls
    "org/gnome/desktop/wm/keybindings" = {
      move-to-monitor-up = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-left = [ ];
    };
  };
}
