{ pkgs, ... }:

{
  home.packages = [ pkgs.parsec-bin ];
  system.allowedUnfree.packages = [ "parsec-bin" ];
}
