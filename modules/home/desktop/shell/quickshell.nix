{ pkgs, ... }:

{
  programs.quickshell = {
    enable = true;
    configs.main = ./config;
    activeConfig = "main";
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
  home.packages = with pkgs; [
    quickshell
    material-symbols
  ];
  systemd.user.services.quickshell.Service.Environment = [
    "QS_APP_ID=org.exsmachina.shell"
    "QS_DISABLE_FILE_WATCHER=1"
    "QS_DISABLE_CRASH_HANDLER=1"
    "QS_NO_RELOAD_POPUP=1"
    "QS_DROP_EXPENSIVE_FONTS=1"
  ];
}
