{ pkgs, lib, globals, ... }:

{
  services.nextcloud = lib.fix (self: {
    enable = globals.server.dns.exists;
    package = pkgs.nextcloud31;
    hostName = "nextcloud.${globals.server.dns.basename}";
    https = true;
    appstoreEnable = true;
    config = {
      dbtype = "sqlite";
    };
  });
  environment.persistence."/nix/host/state/Servers/Nextcloud".directories = [
    { directory = "/var/lib/nextcloud"; user = "nextcloud"; group = "nextcloud"; }
  ];
}