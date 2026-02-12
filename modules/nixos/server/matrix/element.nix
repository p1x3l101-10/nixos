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

    locations."/".root = pkgs.element-web.override {
      conf = {
        default_server_config = clientConfig;
        features = {
          feature_video_rooms = true;
          feature_group_calls = true;
          feature_element_call_video_rooms = true;
        };
        element_call = {
          url = "https://call.element.io";
          use_exclusively = true;
        };
      };
    };
  };
}
