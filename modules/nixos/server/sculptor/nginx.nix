{ config, ... }:

{
  services.nginx = {
    virtualHosts."sculptor.piplup.pp.ua" = {
      onlySSL = true;
      enableACME = false; # Wait until dns finally updates
      locations."/" = {
        proxyPass = "http://127.0.0.1:25575";
        proxyWebsockets = true;
      };
    };
  };
}