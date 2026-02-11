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
    };
  };
}
