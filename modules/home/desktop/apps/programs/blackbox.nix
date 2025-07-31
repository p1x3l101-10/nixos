{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blackbox-terminal
  ];
}
