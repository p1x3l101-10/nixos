{ pkgs, ... }:

{
  home.packages = [ pkgs.stremio-linux-shell ];
  home.allowedUnfree.packages = [
    "stremio-linux-shell"
    "stremio-server"
  ];
}
