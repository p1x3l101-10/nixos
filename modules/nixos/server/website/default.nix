{ globals, ... }:

{
  config = globals.server.dns.required {
    services.nginx.virtualHosts."${globals.server.dns.basename}" = {
      addSSL = true;
      enableACME = true;
      locations."/".root = ./webpage;
    };
  };
}