{ pkgs, config, ... }:

{
  services.nginx.virtualHosts."admin.matrix.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".root = pkgs.synapse-admin-etkecc;
  };
}
