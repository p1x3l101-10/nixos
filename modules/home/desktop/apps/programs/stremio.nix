{ pkgs, ... }:

{
  home.packages = [ pkgs.stremio ];
  home.allowedUnfree.packages = [
    "stremio-client"
    "stremio-server"
  ];
}
