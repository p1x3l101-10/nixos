{ config, ... }:

let
  domain = config.networking.domain;
in {
  services.go-autoconfig = {
    enable = config.services.opensmtpd.enable;
    settings = {
      service_addr = ":1323";
      domain = "autoconfig.${domain}";
      imap = {
        server = "mail." + domain;
        port = 993;
      };
      smtp = {
        server = "mail." + domain;
        port = 587;
      };
    };
  };
  services.nginx.virtualHosts."autoconfig.${domain}" = {
    enableACME = true;
    locations."/".proxyPass = "http://[::1]:1323";
  };
}
