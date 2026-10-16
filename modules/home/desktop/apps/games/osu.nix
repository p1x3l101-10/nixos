{ ext, ... }:

{
  home.packages = [
    ext.selfPkgs.osu-lazer-bin
  ];
  home.allowedUnfree.packages = [ "osu-lazer-bin" ];
}
