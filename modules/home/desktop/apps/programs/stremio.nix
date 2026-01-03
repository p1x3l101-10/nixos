{ pkgs, ext, ... }:

let
  inherit (ext) stablePkgs;
in

{
  home.packages = [ stablePkgs.stremio ];
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
