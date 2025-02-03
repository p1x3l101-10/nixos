{ lib, pkgs, ... }:
{
  programs.java.enable = true;
  programs.dconf.enable = true; # Fix issues in HM WMs
}
