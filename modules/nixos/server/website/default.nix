{ globals, pkgs, ... }:

{
  config = globals.server.dns.required {
    services.nginx.virtualHosts."${globals.server.dns.basename}" = {
      addSSL = true;
      enableACME = true;
      locations."/".root = pkgs.internal.aya.build {
        src = ./webpage;
      };
    };
  };
}