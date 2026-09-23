{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #ouch
    ouch-rar
  ];
  home.allowedUnfree.packages = [
    "ouch" # the rar component is unfree, everything else is free
  ];
}
