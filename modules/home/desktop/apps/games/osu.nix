{ pkgs, ... }:

{
  home.packages = [ pkgs.osu-lazer-bin ];
  home.allowedUnfree.packages = [ "osu-lazer-bin" ];
}
