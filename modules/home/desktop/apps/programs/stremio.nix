{ pkgs, ... }:

{
  /*
  home.packages = [ pkgs.stremio ];
  home.allowedUnfree.packages = [
    "stremio-shell"
    "stremio-server"
  ];
  */
  home.packages = [ pkgs.internal.stremio-linux-shell ];
}
