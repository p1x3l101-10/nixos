{ config, userdata, ... }:

{
  services.nginx.virtualHosts."sculptor.${userdata "domainName" [ "server" ]}" = {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:25575";
      proxyWebsockets = true;
    };
  };
}