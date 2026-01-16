{ pkgs, osConfig, ... }:

{
  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
  home.packages = with pkgs; [
    quickshell
    material-symbols
  ];
  systemd.user.tmpfiles.rules = [
    "L /home/pixel/.config/quickshell - - - - ${osConfig.environment.etc."nixos".source}/modules/home/desktop/shell/config"
  ];
}
