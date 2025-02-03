{ ... }:
{
  services.samba = {
    enable = true;
    nsswins = true;
    openFirewall = true;
    shares.public = {
      path = "/home/pixel/Public";
      "read only" = true;
      browsable = "yes";
      "guest ok" = "yes";
      comment = "Public samba share";
    };
  };

  # Why wont it let me see that darn nas?
  networking.extraHosts = ''
    192.168.1.92 nassy.local
  '';
}
