{ pkgs, lib, globals, ... }:

{
  services.nextcloud = lib.fix (self: {
    enable = true;
    package = pkgs.nextcloud31;
    hostname = "nextcloud.${globals.server.dns.basename}";
    https = true;
    apps = {
      inherit (self.package.packages.apps)
        news
        contacts
        calendar
        tasks
      ;
    };
    extraAppsEnable = true;
    config = {
      dbtype = "sqlite";
      adminuser = "internal-admin";
      adminpassFile = "/nix/host/keys/nextcloud/admin-password.txt";
    };
  });
  environment.persistence."/nix/host/state/Servers/Nextcloud".directories = [
    "/var/lib/nextcloud"
  ];
}