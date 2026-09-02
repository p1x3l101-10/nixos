{ pkgs, ... }:

{
  home.packages = [
    (pkgs.libreoffice-qt6-fresh.overrides {
      langs = [
      "en-US"
      ];
      withFonts = true;
    })
  ];
}
