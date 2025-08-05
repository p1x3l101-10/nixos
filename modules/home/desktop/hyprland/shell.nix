{ config, pkgs, osConfig, ... }:

{
  home.packages = with pkgs; [ quickshell ];
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Hyprland Shell";
      Wants = [
        "systemd-tmpfiles-setup.service"
        "systemd-tmpfiles-clean.service"
      ];
      After = [
        "systemd-tmpfiles-setup.service"
        "systemd-tmpfiles-clean.service"
      ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell";
      Environment = "QML_XHR_ALLOW_FILE_READ=1";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
  systemd.user.tmpfiles.rules = [
    "L /home/pixel/.config/quickshell - - - - ${osConfig.environment.etc."nixos".source}/modules/home/desktop/hyprland/shell"
  ];
}
