{ lib, config, ... }:

let
  serverGlobals = import ../../../../nixos/server/globals.nix { inherit lib; };
  matrixServerConf = import ../../../../nixos/server/matrix/config.nix {
    inherit lib;
    matrix_fqdn = "matrix.${serverGlobals.server.dns.basename}";
  };
in {
  programs.element-desktop = {
    enable = true;
    settings = {
      default_server_config = matrixServerConf.clientConfig;
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
}
