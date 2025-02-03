{ ... }:
{
  services.samba = {
    enable = true;
    nsswins = true;
    openFirewall = true;
  };

  # Why wont it let me see that darn nas?
  networking.extraHosts = ''
    192.168.1.92 nassy.local
  '';
}
