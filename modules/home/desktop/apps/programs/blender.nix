{ pkgs, ... }:

{
  home.packages = [
    pkgs.pkgsRocm.blender
  ];
}
