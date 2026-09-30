{ clockFormat, colors, fonts, opacity }:

{
  modules = {
    left = [
      "Tempo"
      "SystemInfo"
    ];
    center = [
      "Workspaces"
    ];
    right = [
      [
        "Tray"
        "Privacy"
        "Settings"
      ]
      "Notifications"
    ];
  };
  tempo.clock_format = clockFormat.long;
  workspaces = {
    visibility_mode = "MonitorSpecific";
  };
  notifications = {
    format = "%m/%d %H:%M";
    show_timestamps = true;
    grouped = true;
    toast_position = "TopRight";
    toast = true;
  };
  system_info = {
    indicators = [
      "Cpu"
      "Memory"
      "MemorySwap"
      { Disk = "/nix"; }
    ];
    cpu = {
      warn_threshold = 60;
      alert_threshold = 80;
    };
    memory = {
      warn_threshold = 80;
      alert_threshold = 95;
    };
    disk = {
      mounts = [
        "/nix"
        "/efi"
      ];
      warn_threshold = 80;
      alert_threshold = 90;
    };
  };
  settings = {
    battery_format = "IconAndPercentage";
    peripheral_battery_format = "Icon";
    peripheral_indicators = {
      Specific = [
        "Gamepad"
        "Keyboard"
      ];
    };
    indicators = [
      "IdleInhibitor"
      "PowerProfile"
      "Audio"
      "Bluetooth"
      "Network"
      "Vpn"
      "Battery"
    ];
    shutdown_cmd = "systemctl shutdown";
    suspend_cmd = "systemctl suspend";
    reboot_cmd = "systemctl reboot";
    logout_cmd = "loginctl kill-session $XDG_SESSION_ID";
    audio_sources_more_cmd = "pipewire-control-center";
    audio_sinks_more_cmd = "pipewire-control-center";
    lock_cmd = "loginctl lock-session $XDG_SESSION_ID";
  };
  appearance = with colors.withHashtag; {
    background_color = base00;
    primary_color = base0D;
    secondary_color = base01;
    success_color = base0B;
    danger_color = base08;
    text_color = base05;
    workspace_colors = [
      base0D
      base09
    ];
    opacity = opacity.desktop;
    bar = {
      surface = "solid";
      radius = [
        "none"
        "none"
        "md"
        "md"
      ];
    };
    menu = {
      opacity = opacity.desktop;
      backdrop = 0.3;
    };
  };
}
