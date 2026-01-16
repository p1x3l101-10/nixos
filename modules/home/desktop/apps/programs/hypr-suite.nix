{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprprop
    hyprfreeze
    hyprpwcenter
    hyprsysteminfo
  ];
}
