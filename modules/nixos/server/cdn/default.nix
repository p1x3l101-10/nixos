{ config, globals, ... }:

{
  services.nginx.virtualHosts."cdn.${globals.server.dns.basename}" = globals.server.dns.required {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      root = "/var/lib/http-cdn";
      extraConfig = ''
        autoindex on;
      '';
    };
  };
  environment.persistence."/nix/host/state/Servers/HTTP-CDN".directories = [
    { directory = "/var/lib/http-cdn"; mode = "0770"; group = config.users.groups.http-cdn.name; }
  ];
  users.groups.http-cdn = {
    members = [
      "pixel"
      config.services.nginx.user
      "nextcloud"
    ];
  };
}