{ pkgs, lib, config, ... }:

let
  globals = import ./support/hypr-globals.nix pkgs lib;
in {
  home.packages = with pkgs; [ ashell ];
  xdg.configFile."ashell/config.toml".source = (pkgs.formats.toml { }).generate "ashell-config" {
    log_level = "warn";
    outputs = "All";
    position = "Top";
    app_launcher_cmd = globals.appLauncher;
    clipboard_cmd = globals.clipboardMenu;
    modules = {
      left = [
        "Workspaces"
      ];
      center = [
        "WindowTitle"
      ];
      right = [
        "SystemInfo" [
          "Clock"
          "Privacy"
          "Settings"
        ]
        "CustomNotifications"
      ];
    };
    updates = {
      update_cmd = globals.updates.updater;
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
    clock.format = globals.clockFormat;
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
      lock_cmd = "hyprlock &";
      suspend_cmd = "systemctl suspend";
      reboot_cmd = "systemctl reboot";
      shutdown_cmd = "systemctl poweroff";
      logout_cmd = "loginctl kill-user $(whoami)";
      remove_airplane_btn = true;
      audio_sinks_more_cmd = "None";
      audio_sources_more_cmd = "None";
      wifi_more_cmd = "None";
      vpn_more_cmd = "None";
      bluetooth_more_cmd = "None";
    };
    appearance = {
      font_name = (builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0);
      style = "Islands";
      opacity = 0.7;
      background_color = "#1e1e2e";
      primary_color = "#fab387";
      secondary_color = "#11111b";
      success_color = "#a6e3a1";
      danger_color = "#f38ba8";
      text_color = "#f38ba8";
      workspace_colors = [ "#fab387" ];
      special_workspace_colors = [ "#a6e3a1" ];
      menu = {
        opacity = 0.7;
        backdrop = 0.3;
      };
    };
  };
  systemd.user.services.ashell = {
    Unit = {
      Description = "Hyprland shell";
    };
    Service = {
      ExecStart = "${pkgs.ashell}/bin/ashell";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
