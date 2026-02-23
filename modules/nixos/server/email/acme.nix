{ config, lib, ... }:

let
  domain = "mail.${config.networking.domain}";
in {
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
  services.opensmtpd.serverConfiguration = let
    creds = "/run/credentials/opensmtpd.service"
  in ''
    pki ${domain} cert "${creds}/cert.pem"
    pki ${domain} key "${creds}/key.pem"
  '';
  systemd.services.opensmtpd = {
    requires = [ "acme-${domain}.service" ];
    serviceConfig.LoadCredential = let
      inherit (config.security.acme.certs."${domain}") directory;
    in [
      "key.pem:${directory}/key.pem"
      "cert.pem:${directory}/cert.pem"
    ];
  };
  security.acme.certs."${domain}".postRun = ''
    systemctl restart opensmtpd
  '';
}
