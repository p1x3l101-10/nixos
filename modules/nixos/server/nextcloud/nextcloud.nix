{ pkgs, lib, userdata, ... }:

{
  services.nextcloud = lib.fix (self: {
    enable = true;
    package = pkgs.nextcloud31;
    hostname = "nextcloud.${userdata "domainName" [ "server" ]}";
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