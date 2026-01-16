{
  modules = {
    center = [
      "Clock"
    ];
    left = [
      "Workspaces"
      "MediaPlayer"
    ];
    right = [
      "SystemInfo"
      [
        "Tray"
        "Privacy"
        "Settings"
      ]
    ];
  };
  workspaces = {
    visibility_mode = "MonitorSpecific";
  };
  system_info = {
    indicators = [
      "Cpu"
      "Memory"
      "MemorySwap"
      { Disk = "/nix"; }
      "DownloadSpeed"
      "UploadSpeed"
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
    audio_sources_more_cmd = "hyprpwcenter";
    audio_sinks_more_cmd = "hyprpwcenter";
    lock_cmd = "loginctl lock-session $XDG_SESSION_ID";
  };
  appearance = {
    style = "Gradient";
  };
}
