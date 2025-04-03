{ config, ... }:

{
  services = {
    nextcloud.https = true;
    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
  };
  security.acme = {
    acceptTerms = true;   
    certs = { ${config.services.nextcloud.hostName}.email = "your-letsencrypt-email@example.com"; 
    }; 
  };
}