{ config, lib, ... }:

let
  domain = "mail.${config.networking.domain}";
  inherit (config.security.acme) certs;
  ssl = let
    inherit (certs."${domain}") directory;
  in {
    key = "${directory}/key.pem";
    cert = "${directory}/cert.pem";
  };
in {
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
  services.opensmtpd.serverConfiguration = ''
    pki ${domain} cert "${ssl.cert}"
    pki ${domain} key "${ssl.key}"
  '';
}
