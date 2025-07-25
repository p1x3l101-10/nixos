{ globals, lib, pkgs, ... }:

let
  bluemap_port = 8100;
in
{
  services.minecraft.settings.extraPorts = [
    bluemap_port
  ];
  services.nginx = {
    virtualHosts."mc-map.${globals.server.dns.basename}" = globals.server.dns.required {
      addSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:${toString bluemap_port}";
    };
  };
}
