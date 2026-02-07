{ pkgs, lib, userdata, ... }:

{
  users.users.pixel = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = userdata "sshKeys" [ "scott" ];
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$NSMuZ83C3iGB1HqRhcZOy.$6CGZk2KH94gE/gjBro9vioOkOFJw.a4rhQKJI4HzBB9";
    packages = with pkgs; [
      borgbackup
      vim
    ];
    subUidRanges = [{ count = 65536; startuid = 100000; }];
    subGidRanges = [{ count = 65536; startuid = 100000; }];
  };
  users.users.root.openssh.authorizedKeys.keys = userdata "sshKeys" [ "scott" ];
  users.mutableUsers = false;
  services.openssh.settings.AllowUsers = [ "pixel" "root" ];
  environment.etc.nixos.source = "/home/pixel/nixos";
  environment.shells = with pkgs; [
    nushell
  ];
  users.defaultUserShell = "${pkgs.nushell}/bin/nu";
  environment.persistence."/nix/host/state/UserData".users.pixel.directories = [
    ".ssh"
    "nixos"
    "dump"
  ];
  programs.git.config = {
    user = {
      name = "Pixel";
      email = "scott.blatt.0b10@gmail.com";
    };
    init.defaultBranch = "main";
  };
  systemd.tmpfiles.settings."10-sudo-lectures"."/var/db/sudo/lectured/1001".f = {
    user = "root";
    group = "root";
    mode = "-";
  };
}
