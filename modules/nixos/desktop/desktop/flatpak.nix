{ ... }:
{
  services.flatpak.enable = true;
  hardware.steam-hardware.enable = true;
  # Fix dir permissions
  systemd.tmpfiles.settings."99-permission-fixes"."/var/lib/flatpak/repo".d = {
    user = "root";
    group = "root";
    mode = "0777";
  };
}
