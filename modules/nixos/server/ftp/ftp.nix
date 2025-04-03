{ ... }:

{
  systemd.tmpfiles.settings."50-ftpd"."/var/ftp".z = {
    mode = "2770";
    user = "vsftpd";
    group = "vsftpd";
  };
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    localRoot = "/var/ftp";
    extraConfig = ''
      local_umask=007
    '';
  };
}