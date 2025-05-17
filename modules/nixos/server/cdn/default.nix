{ config, globals, ... }:

{
  services.nginx.virtualHosts."cdn.${globals.server.dns.basename}" = globals.server.dns.required {
    addSSL = true;
    enableACME = true;
    locations."/".root = "/var/lib/http-cdn";
  };
  environment.persistence."/nix/host/state/Servers/HTTP-CDN".directories = [
    { directory = "/var/lib/http-cdn"; mode = "0770"; group = "cdn"; }
  ];
  users.groups.http-cdn = {
    members = [
      "pixel"
      config.services.nginx.user
      "nextcloud"
    ];
  };
}