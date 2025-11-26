{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rcon
    mcrcon
  ];
}
