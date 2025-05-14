{ pkgs, ... }:

{
  services.sculptor = {
    enable = true;
    package = pkgs.callPackage ../../../../packages/sculptor { };
    openFirewall = true;
    config = {
      listen.port = 25575;
    };
  };
}