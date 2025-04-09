{ pkgs, lib, ... }:

let
  getdata = key: names: (import ../userdata.nix { inherit lib; }).getdata key names;
in
{
  users.users.pixel = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = getdata "sshKeys" [ "scott" ];
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$NSMuZ83C3iGB1HqRhcZOy.$6CGZk2KH94gE/gjBro9vioOkOFJw.a4rhQKJI4HzBB9";
    packages = with pkgs; [
      borgbackup
      vim
    ];
    uid = 1000; # Prevent issues
    subUidRanges = [{ count = 65536; startuid = 100000; }];
    subGidRanges = [{ count = 65536; startuid = 100000; }];
  };
  users.users.root.openssh.authorizedKeys.keys = getdata "sshKeys" [ "scott" ];
  users.mutableUsers = false;
  services.openssh.settings.AllowUsers = [ "pixel" "root" ];
  environment.etc.nixos.source = "/home/pixel/nix-server";
  environment.persistence."/nix/host/state/UserData".users.pixel.directories = [
    ".ssh"
    "nix-server"
    "dump"
  ];
  programs.git.config = {
    user = {
      name = "Pixel";
      email = "scott.blatt.0b10@gmail.com";
    };
    init.defaultBranch = "main";
  };
  systemd.tmpfiles.settings."10-sudo-lectures"."/var/db/sudo/lectured/1000".f = {
    user = "root";
    group = "root";
    mode = "-";
  };
}
