{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vrc-get
    alcom
    vrcx
  ];
}
