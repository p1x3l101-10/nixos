{ osConfig, ... }:

{
  services.flatpak = {
    enable = osConfig.services.flatpak.enable;
    uninstallUnmanaged = true;
    update = {
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
  };
}
