{ pkgs, ... }:

{
  home.packages = with pkgs; [
    synadm
  ];
}
