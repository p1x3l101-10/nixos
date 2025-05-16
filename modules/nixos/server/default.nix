{ lib, ... }:

{
  # Add a data getter
  _module.args = {
    userdata = key: names: (import ./userdata.nix { inherit lib; }).getdata key names;
  };
  imports = [
    #./factorio
    #./ftp
    #./minecraft
    #./nextcloud
    ./nginx
    #./nix-serve
    #./s3
    ./sculptor
    ./server-base
    ./ssh-forward
    #./terraria
  ];
}