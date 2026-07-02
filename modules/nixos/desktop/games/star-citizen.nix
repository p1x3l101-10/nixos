{ config, lib, ext, ... }:

{
  config = lib.mkIf (config.networking.hostName == "pixels-pc") {
    programs.rsi-launcher = {
      enable = true;
      patchXwayland = true;
      launchCommand = "%command%";
      gamescope = {
        ebabke = true;
        args = [];
      };
      location = "$XDG_DATA_HOME/star-citizen";
      setLimits = true;
      enableNTSync = true;
      enforceWaylandDrv = true;
    };
  };
  nixpkgs.overlays = [
    ext.inputs.nix-citizen.overlays.default
  ];
}
