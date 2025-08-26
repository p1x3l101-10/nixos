{ pkgs, ... }:

{
  home.packages = with pkgs; [
    inochi-session
    inochi-creator
  ];
}
