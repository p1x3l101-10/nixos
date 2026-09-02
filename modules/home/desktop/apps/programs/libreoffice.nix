{ pkgs, ... }:

{
  home.packages = [
    (pkgs.libreoffice-qt6-fresh.override {
      langs = [
      "en-US"
      ];
      withFonts = true;
    })
  ];
}
