{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    #internal.trios
    starsector
  ];
  home.allowedUnfree.packages = [ "starsector" ];
}
