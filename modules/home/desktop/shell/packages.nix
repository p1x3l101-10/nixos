{ pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    material-symbols
  ];
}
