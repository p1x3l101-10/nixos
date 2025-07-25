{ pkgs, lib, globals, ... }:

{
  services.nextcloud = lib.fix (self: {
    enable = globals.server.dns.exists;
    package = pkgs.nextcloud31;
    hostName = "nextcloud.${globals.server.dns.basename}";
    configureRedis = true;
    https = true;
    appstoreEnable = true;
    database.createLocally = true;
    maxUploadSize = "16G";
    config = {
      dbtype = "pgsql";
      adminuser = "internal-admin";
      adminpassFile = "/nix/host/keys/nextcloud/admin-password.txt";
    };
  });
  environment.persistence."/nix/host/state/Servers/Nextcloud".directories = [
    { directory = "/var/lib/nextcloud"; user = "nextcloud"; group = "nextcloud"; }
  ];
  environment.persistence."/nix/host/state/Servers/Postgresql".directories = [
    "/var/lib/postgresql"
  ];
}
