{ config, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      onlySSL = true; # Figura expects https, no reason to use http when its not being exposed
      enableACME = false;  # No domain
      sslCertificate = "/nix/host/keys/nginx-certs/nginx.crt";
      sslCertificateKey = "/nix/host/keys/nginx-certs/nginx.key";
      listen = [
        {
          addr = "0.0.0.0";
          port = 25575;
          ssl = true;
        }
      ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:25576";
        proxyWebsockets = true;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 25575 ];
  # User fixes
  systemd.tmpfiles.settings."10-fix-nginx-keys" = {
    "/nix/host/keys/nginx-certs".Z = {
      user = config.services.nginx.user;
      group = config.services.nginx.group;
    };
  };
}