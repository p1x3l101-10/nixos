{ lib, ... }:

let
  getdata = key: names: (import ../../modules/nixos/server/userdata.nix { inherit lib; }).getdata key names;
in
{
  users.users.pixel = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = getdata "sshKeys" [ "scott" ];
    extraGroups = [ "wheel" ];
  };
  users.mutableUsers = false;
  systemd.tmpfiles.settings."10-sudo-lectures"."/var/db/sudo/lectured/1000".f = {
    user = "root";
    group = "root";
    mode = "-";
  };
  services.openssh.settings.AllowUsers = [ "pixel" ];
  virtualisation = {
    digitalOceanImage.compressionMethod = "bzip2";
    digitalOcean = {
      seedEntropy = true;
      setSshKeys = false;
      setRootPassword = false;
    };
  };
}