{ pkgs, ... }:

{
  home.packages = with pkgs; [
    speedtest
    fast
  ];
}
