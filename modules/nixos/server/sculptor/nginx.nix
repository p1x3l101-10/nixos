{ config, ... }:

{
  services.nginx.virtualHosts."sculptor.piplup.pp.ua" = {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:25575";
      proxyWebsockets = true;
    };
  };
}