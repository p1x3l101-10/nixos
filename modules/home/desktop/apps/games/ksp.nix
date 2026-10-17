{ pkgs, osConfig, lib, ... }:

lib.mkIf (osConfig.networking.hostName == "stellar-pc") {
  # Mod manager
  home.packages = [ pkgs.ckan ];
}
