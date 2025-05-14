{ config, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      onlySSL = true; # Figura expects https, no reason to use http when its not being exposed
      enableACME = false;  # No domain
      sslCertificate = "/run/secrets/nginx/nginx.crt";
      sslCertificateKey = "/run/secrets/nginx/nginx.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:25575";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # User fixes
  systemd.tmpfiles.settings."10-fix-nginx-keys" = {
    "/nix/host/keys/nginx-certs".Z = {
      user = config.services.nginx.user;
      group = config.services.nginx.group;
    };
  };
}