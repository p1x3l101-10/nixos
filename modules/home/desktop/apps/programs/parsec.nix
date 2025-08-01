{ pkgs, ... }:

{
  home.packages = [ pkgs.parsec-bin ];
  home.allowedUnfree.packages = [ "parsec-bin" ];
}
