{ pkgs, ext, ... }:

let
  inherit (ext) inputs system;
  app2unit = inputs.app2unit.packages.${system}.app2unit;
in {
  home = {
    packages = [ app2unit ];
    sessionVariables = {
      APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
    };
  };
}
