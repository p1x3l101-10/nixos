{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprprop
    wl-freeze
    hyprpwcenter
    hyprsysteminfo
  ];
}
