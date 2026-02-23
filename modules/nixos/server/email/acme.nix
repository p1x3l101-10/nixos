{ config, lib, ... }:

let
  domain = "mail.${config.networking.domain}";
  inherit (config.services.nginx.virtualHosts."${domain}") sslCertificateKey sslCertificate;
in {
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
  services.opensmtpd.serverConfiguration = ''
    pki ${domain} cert "${sslCertificate}"
    pki ${domain} key "${sslCertificateKey}"
  '';
}
