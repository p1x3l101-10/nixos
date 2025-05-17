{ pkgs, lib, globals, ... }:

{
  services.nextcloud = lib.fix (self: {
    enable = globals.server.dns.exists;
    package = pkgs.nextcloud31;
    hostName = "nextcloud.${globals.server.dns.basename}";
    https = true;
    extraApps = {
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
  systemd.tmpfiles.settings."10-fix-nextcloud-passwd" = {
    "/nix/host/keys/nginx-certs".Z = {
      user = "nextcloud";
      group = "nextcloud";
    };
  };
}