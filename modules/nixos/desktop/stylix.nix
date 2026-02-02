{ pkgs, config, ext, lib, ... }:

let
  genWallpaper = name: import (./. + "/support/stylix/wallpapers/${name}.nix") { inherit pkgs config ext; };
  aspectRatio = (lib.internal.lists.switch [
    { case = (config.networking.hostName == "pixels-pc"); out = [ 1920 1080 ]; }
  ] [ null null ]
  );
in {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/helios.yaml";
    #image = genWallpaper "cat";
    image = genWallpaper "nixos" {
      width = builtins.elemAt aspectRatio 0;
      height = builtins.elemAt aspectRatio 1;
      logoScale = 4.0;
    };
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
