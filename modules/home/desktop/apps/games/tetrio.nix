{ pkgs, ... }:

{
  home.packages = [
    ((pkgs.tetrio-desktop.override { withTetrioPlus = false; }).overrideAttrs (oldAttrs: {
      version = "10";

      src = pkgs.fetchzip {
        url = "https://tetr.io/about/desktop/builds/10/TETR.IO%20Setup.deb";
        hash = "sha256-2FtFCajNEj7O8DGangDecs2yeKbufYLx1aZb3ShnYvw=";
        nativeBuildInputs = [ pkgs.dpkg ];
      };
    }))
  ];
  home.allowedUnfree.packages = [
    "tetrio-desktop"
    "tetrio-plus"
  ];
}
