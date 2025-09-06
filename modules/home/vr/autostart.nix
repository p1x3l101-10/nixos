{ pkgs, lib, ... }:

let
  makeSimpleService = name: package: {
    Unit = {
      Description = name;
      PartOf = [ "virtualReality.target" ];
    };
    Service = {
      ExecStart = lib.getBin package;
    };
    Install = {
      WantedBy = [ "virtualReality.target" ];
    };
  };
in {
  systemd.user.services = {
    wlx-overlay-s = makeSimpleService "VR Overlay" pkgs.wlx-overlay-s;
  };
}
