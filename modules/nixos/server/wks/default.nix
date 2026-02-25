{ globals, pkgs, config, ext, ... }:

{
  services.nginx.virtualHosts."openpgpkey.${config.networking.domain}" = globals.server.dns.required {
    addSSL = true;
    enableACME = true;
    locations."/.well-known/openpgpkey" = {
      root = ./keyserver;
    };
  };
}
