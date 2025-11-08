{ pkgs, lib, ... }:

{
  home.packages = [
    ((pkgs.tetrio-desktop.override { withTetrioPlus = true; }).overrideAttrs (oldAttrs: (lib.fixedPoints.fix (finalAttrs: {
      version = "10";

      src = pkgs.fetchzip {
        url = "https://tetr.io/about/desktop/builds/${finalAttrs.version}/TETR.IO%20Setup.deb";
        hash = "sha256-2FtFCajNEj7O8DGangDecs2yeKbufYLx1aZb3ShnYvw=";
        nativeBuildInputs = [ pkgs.dpkg ];
      };
    }))))
  ];
  home.allowedUnfree.packages = [
    "tetrio-desktop"
    "tetrio-plus"
  ];
}
