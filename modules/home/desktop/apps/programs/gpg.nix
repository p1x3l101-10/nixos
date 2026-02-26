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
    scdaemonSettings = {
      disable-ccid = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    pinentry = {
      program = "pinentry-curses";
      package = pkgs.pinentry-all;
    };
  };
  # GPG module does not set this itself and completly breaks itself when used :(
  home.sessionVariables.GNUPGHOME = "${config.programs.gpg.homedir}";
  systemd.user.sessionVariables.GNUPGHOME = "${config.home.sessionVariables.GNUPGHOME}";
}
