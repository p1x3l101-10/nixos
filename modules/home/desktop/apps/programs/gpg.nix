{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = true;
    mutableTrust = true;
    publicKeys = [];
  };
  services.gpg-agent = {
    enable = true;
    pinentry = {
      program = "pinentry-curses";
      package = pkgs.pinentry-all;
    };
  };
}
