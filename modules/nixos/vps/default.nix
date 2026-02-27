{ config, lib, ... }:

let
  srvGlobals = import ../server/globals.nix { inherit lib; };
  globals = {
    type = "vps";
    wireguard = {
      inherit (srvGlobals.wireguard) firewallMark table;
      ipv4 = "";
      ipv6 = "";
    };
    inherit (srvGlobals) dirs badips;
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
