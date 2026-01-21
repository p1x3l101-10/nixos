{ pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      General.ConfigVersion = 2;
      Browser = {
        Enabled = true;
        CustomProxyLocation = "";
      };
      FdoSecrets.Enabled = true;
      GUI.TrayIconAppearance = "monochrome-light";
      SSHAgent.Enabled = false;
      Security.IconDownloadFallback = true;
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
