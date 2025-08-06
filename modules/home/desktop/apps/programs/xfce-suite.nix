{ pkgs, ... }:

{
  home.packages = with pkgs.xfce; [
    thunar
    tumbler # Thumbnails
    xarchiver
    xfmpc
  ];
}
