{ pkgs, ... }:

{
  home.packages = [ pkgs.stremio ];
  home.allowedUnfree.packages = [
    "stremio-shell"
    "stremio-server"
  ];
}
