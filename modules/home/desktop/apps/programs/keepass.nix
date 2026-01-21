{ pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    autostart = true;
  };
  home.packages = with pkgs; [
    keepass-diff
    keepass-keeagent
    keepass-qrcodeview
    keepass-otpkeyprov
    kpcli
  ];
}