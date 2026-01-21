{ pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      Browser.Enabled = true;
      SSHAgent.Enabled = true;
    };
  };
  home.packages = with pkgs; [
    keepass-diff
    keepass-keeagent
    keepass-qrcodeview
    keepass-otpkeyprov
    kpcli
  ];
}