{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprprop
    wl-freeze
    hyprsysteminfo
  ];
}
