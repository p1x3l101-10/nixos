{ config, ... }:

{
  services.nginx = {
    virtualHosts."sculptor.piplup.pp.ua" = {
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:25575";
        proxyWebsockets = true;
      };
    };
    virtualHosts."_" = {
      enableACME = false;
      locations."/" = {
        proxyPass = "http://127.0.0.1:25575";
        proxyWebsockets = true;
      };
    };
  };
}