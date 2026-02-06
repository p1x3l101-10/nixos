{ pkgs, ... }:

{
  home.packages = [
    pkgs.r2modman
    /*
    (pkgs.r2modman.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [
        ./support/r2mmp-no-updates.patch
      ];
    }))
    */
  ];
}
