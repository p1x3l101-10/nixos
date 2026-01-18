{ ... }:

{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "right";
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
        avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
    };
  };
}
