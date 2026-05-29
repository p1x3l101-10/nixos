{ osConfig, ... }:

{
  systemd.user.services.flatpak-managed-install.Unit.After = [ "default.target" ];
  services.flatpak = {
    enable = osConfig.services.flatpak.enable;
    #uninstallUnmanaged = true;
    uninstallUnmanaged = false;
    packages = [
      "dev.geopjr.Archives"
    ];
    update = {
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
  };
}
