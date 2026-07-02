{ config, ext, ... }:

{
  programs.rsi-launcher = {
    enable = (config.networking.hostName == "pixels-pc");
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
  nixpkgs.overlays = [
    ext.inputs.nix-citizen.overlays.default
  ];
}
