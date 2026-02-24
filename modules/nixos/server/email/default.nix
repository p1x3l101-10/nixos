{ ext, globals, config, pkgs, ... }:

let
  inherit (config.networking) domain;
  ssl = let
    inherit (config.security.acme.certs."${config.mailserver.fqdn}") directory;
  in {
    key = "${directory}/key.pem";
    cert = "${directory}/cert.pem";
    fullchain = "${directory}/fullchain.pem";
  };
in {
  imports = [
    ext.inputs.nixos-mailserver.nixosModules.mailserver
  ];
  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.${domain}";
    domains = [ domain ];
    x509 = {
      privateKeyFile = ssl.key;
      certificateFile = ssl.fullchain;
    };
    loginAccounts = {
      "postmaster@${domain}" = {
        hashedPassword = "$y$j9T$xIqsbrS7kn13DWVH06nf11$ewQiB0.UkYcVSCIU5XqfuV9Ej4ss5.m1ATkks7YSU/9";
      };
      "pixel@${domain}" = {
        hashedPassword = "$y$j9T$ChefBxNe7LttV2jeKpeo00$DZJxTcIlROpaFyfUV109btSMI9khiDxDvugU/dUnLD3";
      };
    };
  };
  # Let NGINX handle ACME certs
  services.nginx.virtualHosts."${config.mailserver.fqdn}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
}
