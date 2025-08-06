{ pkgs, ... }:

{
  home.packages = with pkgs.xfce; [
    thunar
    tumbler # Thumbnails
    pkgs.xarchiver
    xfmpc
  ];
}
