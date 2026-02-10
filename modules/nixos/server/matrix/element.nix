{ globals, lib, config, pkgs, ... }:

let
  matrix_fqdn = "matrix.${config.networking.domain}";
  fqdn = "element.${config.networking.domain}";
  baseUrl = "https://${fqdn}";
  inherit (import ./config.nix { inherit lib matrix_fqdn; }) clientConfig;
in {
  services.nginx.virtualHosts."${fqdn}" = {
    enableACME = true;
    forceSSL = true;
    serverAliases = [ "element.${matrix_fqdn}" ];

    locations."/"root = pkgs.element-web.override {
      conf = {
        default_server_config = clientConfig;
      };
    };
  };
}
