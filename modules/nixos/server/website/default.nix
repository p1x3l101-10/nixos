{ globals, pkgs, ... }:

{
  services.nginx.virtualHosts."${globals.server.dns.basename}" = globals.server.dns.required {
    addSSL = true;
    enableACME = true;
    locations."/".root = pkgs.internal.aya.build {
      src = ./webpage;
      service = ./aya-meta;
    };
  };
}