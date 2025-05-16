{ config, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      enableACME = false;
      locations."/" = {
        proxyPass = "http://127.0.0.1:25575";
        proxyWebsockets = true;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}