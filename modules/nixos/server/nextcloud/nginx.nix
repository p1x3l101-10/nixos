{ config, globals, ... }:

{
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = globals.server.dns.required {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      # kill cache
      add_header Last-Modified $date_gmt;
      add_header Cache-Control 'no-store, no-cache';
      if_modified_since off;
      expires off;
      etag off;
    '';
  };
}