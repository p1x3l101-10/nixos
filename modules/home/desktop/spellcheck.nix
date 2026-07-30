{ pkgs, ... }:

{
  home.packages = (with pkgs; [
    hunspell
    hyphen
  ]) ++ (with pkgs.hunspellDicts; [
    en_US
  ]) ++ (with pkgs.hyphenDicts; [
    en_US
  ]);
}
