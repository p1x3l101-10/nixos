{ pkgs, config, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings.publish = {
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };

  services.printing = {
    enable = true;
    browsing = true;
    browsed = {
      enable = true;
    };
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [
      cups-filters
      gutenprint
      gutenprintBin
    ];
  };
  environment.persistence."/nix/host/state/System".directories = [
    { directory = "/var/lib/cups"; user = config.users.users.cups.name; group = config.users.users.cups.group; mode = "u=rwx,g=rx,o=rx"; }
  ];
  users.users.pixel.extraGroups = [
    "lpadmin"
  ];
}
