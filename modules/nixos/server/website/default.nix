{ globals, pkgs, ... }:

{
  services.nginx.virtualHosts."${globals.server.dns.basename}" = globals.server.dns.required {
    addSSL = false;
    enableACME = false;
    locations."/".root = pkgs.internal.aya.build {
      src = ./webpage;
      service = ./aya-meta;
    };
  };
}