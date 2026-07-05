{ pkgs, ... }:

{
  home.packages = [
    pkgs.internal.osu-lazer-bin
  ];
  home.allowedUnfree.packages = [ "osu-lazer-bin" ];
}
