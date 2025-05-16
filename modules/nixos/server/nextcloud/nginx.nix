{ config, ... }:

{
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableAcme = true;
  };
}