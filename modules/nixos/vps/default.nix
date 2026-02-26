{ config, lib, ... }:

let
  globals = {
    type = "vps";
    dirs = {
      state = "/nix/host/state";
      cache = "/nix/host/cache";
      keys = "/nix/host/keys";
    };
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
