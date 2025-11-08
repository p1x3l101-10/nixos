{ osConfig, ... }:

{
  services.flatpak = {
    enable = osConfig.services.flatpak.enable;
    #uninstallUnmanaged = true;
    uninstallUnmanaged = false;
    update = {
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
  };
}
