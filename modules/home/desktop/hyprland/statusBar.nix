{ pkgs, lib, config, ... }:

let
  globals = import ./support/hypr-globals.nix pkgs lib;
in {
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      log_level = "warn";
      outputs = "All";
      position = "Top";
      app_launcher_cmd = globals.appLauncher;
      clipboard_cmd = globals.clipboardMenu;
      modules = {
        left = [
          "Workspaces"
          "MediaPlayer"
        ];
        center = [
          "WindowTitle"
        ];
        right = [
          "SystemInfo"
          "Tray"
          [
            "Clock"
            "Privacy"
            "Settings"
          ]
          "CustomNotifications"
        ];
      };
      workspaces = {
        visibility_mode = "All";
        enable_workspace_filling = true;
      };
      window_title = {
        mode = "Title";
        truncate_after_length = 150;
      };
      system = lib.fix (self: {
        indicators = [
          "Cpu"
          "Memory"
          "Temperature"
        ];
        cpu = {
          warn_threshold = 80;
          alert_threshold = 95;
        };
        memory = self.cpu;
        temperature = self.cpu;
        disk = {
          warn_threshold = 70;
          alert_threshold = 90;
        };
      });
      clock.format = globals.clockFormat.time;
      media_player.max_title_length = 100;
      CustomModule = [
        {
          name = "CustomNotifications";
          icon = "";
          command = globals.notifications.checker;
          icons."dnd.*" = "";
          alert = ".*notification";
        }
      ];
      settings = {
        lock_cmd = "loginctl lock-session $XDG_SESSION_ID";
        suspend_cmd = "systemctl suspend";
        reboot_cmd = "systemctl reboot";
        shutdown_cmd = "systemctl poweroff";
        logout_cmd = "hyprctl dispatch exit";
        remove_airplane_btn = true;
        audio_sinks_more_cmd = "None";
        audio_sources_more_cmd = "None";
        wifi_more_cmd = "None";
        vpn_more_cmd = "None";
        bluetooth_more_cmd = "None";
      };
      appearance = {
        style = "Islands";
        menu.backdrop = 0.3;
      };
    };
  };
}
