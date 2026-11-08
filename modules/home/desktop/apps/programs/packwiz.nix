{ pkgs, ... }:

{
  home.packages = with pkgs; [
    packwiz
    signify
  ];
}
