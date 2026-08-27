{ pkgs, config, ext, lib, ... }:

let
  genWallpaper = name: import (./. + "/support/stylix/wallpapers/${name}.nix") { inherit pkgs config ext; };
  aspectRatio = (ext.lib.lists.switch [
    { case = (config.networking.hostName == "stellar-pc"); out = [ 1920 1080 ]; }
    { case = (config.networking.hostName == "stellar-laptop"); out = [ 2560 1600 ]; }
  ] [ null null ]
  );
in {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/helios.yaml";
    image = ext.assets.img.hyprpapers."legacy1.png";
    /*
    #image = genWallpaper "cat";
    image = genWallpaper "nixos" {
      width = builtins.elemAt aspectRatio 0;
      height = builtins.elemAt aspectRatio 1;
      logoScale = 4.0;
    };
    */
    polarity = "dark";
    targets = { };
    icons = {
      enable = true;
      light = "Adwaita";
      dark = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
