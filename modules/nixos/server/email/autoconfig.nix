{ config, ... }:

let
  domain = config.services.maddy.primaryDomain;
in {
  services.go-autoconfig = {
  enable = config.services.maddy.enable;
    settings = {
      service_addr = ":1323";
      domain = "autoconfig.${domain}";
      imap = {
        server = domain;
        port = 993;
      };
      smtp = {
        server = domain;
        port = 587;
      };
    };
  };
  services.nginx.virtualHosts."autoconfig.${domain}" = {
    enableACME = true;
    locations."/".proxyPass = "http://[::1]${config.services.go-autoconfig.service_addr}";
  };
}
