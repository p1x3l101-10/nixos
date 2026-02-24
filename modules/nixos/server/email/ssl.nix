{ ext, globals, config, pkgs, ... }:

let
  ssl = let
    inherit (config.security.acme.certs."${config.mailserver.fqdn}") directory;
  in {
    key = "${directory}/key.pem";
    cert = "${directory}/cert.pem";
    fullchain = "${directory}/fullchain.pem";
  };
in {
  mailserver.x509 = {
    privateKeyFile = ssl.key;
    certificateFile = ssl.fullchain;
  };
  # Let NGINX handle ACME certs
  services.nginx.virtualHosts."${config.mailserver.fqdn}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
}
