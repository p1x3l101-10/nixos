{ pkgs, ext, ... }:

let
  inherit (ext) inputs system;
  app2unit = inputs.app2unit.packages.${system}.app2unit;
in {
  home.packages = [ app2unit ];
}
