{ pkgs, ... }:

{
  home.packages = [
    (pkgs.tetrio-desktop.override { withTetrioPlus = true; })
  ];
  home.allowedUnfree.packages = [
    "tetrio-desktop"
    "tetrio-plus"
  ];
}
