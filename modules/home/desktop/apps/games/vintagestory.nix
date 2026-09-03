{ pkgs, ... }:

{
  home.packages = [ pkgs.vintagestory ];
  home.allowedUnfree.packages = [
    "vintagestory"
  ];
}
