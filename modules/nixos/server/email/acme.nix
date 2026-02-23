{ config, lib, ... }:

let
  domain = "mail.${config.networking.domain}";
in {
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
  services.opensmtpd.serverConfigurations = ''
    pki ${domain} cert "${sslCertificate}"
    pki ${domain} key "${sslCertificateKey}"
  '';
}
