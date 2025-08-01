{ pkgs, ... }:

{
  home.packages = [ pkgs.stremio ];
  system.allowedUnfree.packages = [
    "stremio-client"
    "stremio-server"
  ];
}
