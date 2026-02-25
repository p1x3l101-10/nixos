{ config, pkgs, ext, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      # Yubikey GPG key
      {
        trust = "ultimate";
        source = ext.assets.keys."yubikey.gpg.pub";
      }
    ];
  };
  services.gpg-agent = {
    enable = true;
    pinentry = {
      program = "pinentry-curses";
      package = pkgs.pinentry-all;
    };
  };
}
