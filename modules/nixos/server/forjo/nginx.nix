{ globals, config, ... }:

let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in {
  services.nginx = {
    virtualHosts.${cfg.settings.server.DOMAIN} = globals.server.dns.required {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
    };
  };
}