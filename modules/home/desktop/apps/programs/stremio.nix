{ ext, ... }:

let
  pkgs = ext.rawPkgs {
    nixpkgs = ext.stable.input;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };
  };
in

{
  home.packages = [ pkgs.stremio ];
  home.allowedUnfree.packages = [
    "stremio-shell"
    "stremio-server"
  ];
  /*
  home.packages = [ pkgs.internal.stremio-linux-shell ];
  home.allowedUnfree.packages = [
    "stremio-linux-shell"
    "stremio-server"
  ];
  */
}
