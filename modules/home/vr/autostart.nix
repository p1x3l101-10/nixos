{ pkgs, lib, ... }:

let
  makeSimpleService = name: binary: {
    Unit = {
      Description = name;
      PartOf = [ "virtualReality.target" ];
    };
    Service = {
      ExecStart = binary;
    };
    Install = {
      WantedBy = [ "virtualReality.target" ];
    };
  };
in {
  systemd.user.services = {
    wlx-overlay-s = makeSimpleService "VR Overlay" "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s";
  };
}
