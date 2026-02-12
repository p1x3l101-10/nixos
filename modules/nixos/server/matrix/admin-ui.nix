{ pkgs, config, ... }:

{
  services.nginx.virtualHosts."admin.${config.services.matrix-synapse.settings.public_baseurl}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".root = pkgs.synapse-admin-etkecc;
  };
}
