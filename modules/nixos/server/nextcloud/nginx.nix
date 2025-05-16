{ config, globals, ... }:

{
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = globals.server.dns.required {
    forceSSL = true;
    enableAcme = true;
  };
}