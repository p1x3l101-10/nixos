{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ quickshell ];
  xdg.configFile.quickshell = {
    source = config.lib.file.mkOutOfStoreSymlink ./shell;
    #recursive = true;
  };
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Hyprland Shell";
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
