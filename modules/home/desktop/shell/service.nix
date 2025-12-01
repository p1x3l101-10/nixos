{ pkgs, ... }:

{
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
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
}
