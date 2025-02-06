{ pkgs, ... }:
let
  pfx = "/private/var/tmp/nix";
in {
  nix.package = pkgs.nixVersions.latest.override {
    storeDir = "${pfx}/store";
    stateDir = "${pfx}/var";
    confDir = "${pfx}/etc";
  };
  system.stateVersion = 6;
}