{ config, ... }:

{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "top";
        floating = true;
        showCapsule = false;
        left = [
          {
            id = "ControlCenter";
            useDistroLogo = true;
          }
          {
            id = "Network";
          }
          {
            id = "Bluetooth";
          }
        ];
        center = [
          {
            hideUnoccupied = false;
            id = "Workspace";
            labelMode = "none";
          }
        ];
        right = [
          {
            alwaysShowPercentage = false;
            id = "Battery";
            warningThreshold = 30;
          }
          {
            formatHorizontal = "HH:mm";
            formatVertical = "HH mm";
            id = "Clock";
            useMonospacedFont = true;
            usePrimaryColor = true;
          }
        ];
      };
      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        radiusRatio = 0.2;
      };
      location = {
        name = "Oklahoma City OK";
      };
    };
  };
}
