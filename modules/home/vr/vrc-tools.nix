{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vrc-get
    alcom
    vrcx
    unityhub
  ];
  home.allowedUnfree.packages = [
    "unityhub"
    "corefonts"
  ];
}
