{ config, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      listen = [
        { addr = "0.0.0.0"; port = 443; ssl = true; }
        { addr = "0.0.0.0"; port = 80; ssl = false; }
      ];

      enableACME = false;  # No domain
      sslCertificate = "/run/secrets/nginx/nginx.crt";
      sslCertificateKey = "/run/secrets/nginx/nginx.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:25575";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}