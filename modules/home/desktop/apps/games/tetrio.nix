{ pkgs, ... }:

{
  home.packages = [
    pkgs.tetrio-plus
  ];
  home.allowedUnfree.packages = [
    "tetrio-plus"
  ];
}
