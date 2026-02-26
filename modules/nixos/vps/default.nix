{ config, ... }:

let
  globals = {
    type = "vps";
    dirs = {
      state = "/nix/host/state";
      cache = "/nix/host/cache";
      keys = "/nix/host/keys";
    };
  };

  userdata = import ../server/userdata.nix { inherit lib globals; };
in {
  _module.args = {
    inherit globals userdata;
  };
  imports = [
    ./server-base
    ./wireguard
  ];
  networking = {
    domain = "exsmachina.org";
    fqdn = "srv02.${config.networking.domain}";
  };

}
