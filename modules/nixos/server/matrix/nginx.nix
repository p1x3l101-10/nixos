{ globals, config, ... }:

{
  services.nginx = {
    virtualHosts."matrix.${globals.server.dns.basename}" = globals.server.dns.required {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.matrix-conduit.port}";
        proxyWebsockets = true;
      };
    };
  };
}