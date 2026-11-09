{ ext, ... }:

{
  home.packages = [
    ext.selfPkgs.games.osu-lazer-bin
  ];
  home.allowedUnfree.packages = [ "osu-lazer-bin" ];
}
