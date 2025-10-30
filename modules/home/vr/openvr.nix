{ pkgs, config, ... }:

{
  xdg.configFile."openvr/openvrpaths.vrpath" = {
    text = (builtins.toJSON {
      version = 1;
      config = [
        "${config.xdg.dataHome}/Steam/config"
      ];
      log = [
        "${config.xdg.dataHome}/Steam/logs"
      ];
      external_drivers = null;
      jsonid = "vrpathreg";
      runtime = [
        "${pkgs.opencomposite}/lib/opencomposite"
      ];
    });
    force = true;
  };
}
