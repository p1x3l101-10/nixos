{ pkgs, config, ext, ... }:

let
  genWallpaper = name: import (./. + "/support/stylix/wallpapers/${name}.nix") { inherit pkgs config ext; };
in {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/helios.yaml";
    image = genWallpaper "cat";
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
