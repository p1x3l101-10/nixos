{ lib, ... }:

let
  globals = (import ./globals.nix { inherit lib; });
  userdata = key: names: (import ./userdata.nix { inherit lib globals; }).getdata key names;
in {
  _module.args = {
    inherit globals userdata;
  };
  imports = [
    ./forjo
    ./mastodon
    ./nextcloud
    ./nginx
    ./sculptor
    ./server-base
    ./ssh-forward
    ./website
  ];
}