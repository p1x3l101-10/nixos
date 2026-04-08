{ pkgs, ... }:

{
  home.packages = [ pkgs.stremio-linux-shell ];
  home.allowedUnfree.packages = [
    "stremio-linux-shell"
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
