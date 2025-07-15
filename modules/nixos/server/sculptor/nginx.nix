{ config, globals, ... }:

{
  services.nginx.virtualHosts."sculptor.${globals.server.dns.basename}" = globals.server.dns.required {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:25575";
      proxyWebsockets = true;
    };
  };
}
