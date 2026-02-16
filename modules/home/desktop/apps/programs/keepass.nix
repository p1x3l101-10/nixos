{ pkgs, config, ... }:

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
      GUI = {
        ColorPasswords = true;
        MinimizeOnClose = true;
        MinimizeToTray = true;
        MonospaceNotes = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-${config.stylix.polarity}";
      };
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
  programs.zen-browser.nativeMessagingHosts = [
    config.programs.keepassxc.package
  ];
}
