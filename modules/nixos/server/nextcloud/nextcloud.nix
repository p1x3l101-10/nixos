{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "166.113.94.161";
    datadir = "/var/lib/nextcloud";
    config = {
      adminuser = "internal-admin";
      adminpassFile = "/run/secrets/nextcloud/admin-password.txt";
      dbtype = "sqlite";
    };
    extraAppsEnable = true;
  };
  # Make adminPass readable by nextcloud:nextcloud
  systemd.tmpfiles.settings."99-make-files-readable-to-user" = {
    "/run/secrets/nextcloud/admin-password.txt".z = {
      user = "nextcloud";
      group = "nextcloud";
      mode = "0440";
    };
    "/run/secrets/nextcloud".z = {
      user = "root";
      group = "root";
      mode = "0771";
    };
    "/var/lib/nextcloud".z = {
      user = "nextcloud";
      group = "nextcloud";
      mode = "0750";
    };
  };
}