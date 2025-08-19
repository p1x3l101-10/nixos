{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = { };
  };
  home.packages = [ pkgs.inotify-tools ];
}
