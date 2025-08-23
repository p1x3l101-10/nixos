{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openseeface
  ];
}
