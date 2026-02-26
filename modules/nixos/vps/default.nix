{ config, lib, ... }:

let
  globals = {
    type = "vps";
    inherit (import ../server/globals.nix) dirs wireguard;
  };

  userdata = key: names: (import ../server/userdata.nix { inherit lib globals; }).getdata key names;
in {
  _module.args = {
    inherit globals userdata;
  };
  imports = [
    ./server-base
    ./ssh-tunnel
    ./wireguard
  ];
  networking = {
    domain = "exsmachina.org";
    fqdn = "srv02.${config.networking.domain}";
  };

}
