{ ext, osConfig, lib, ... }:

let
  gamePkgs = ext.inputs.nix-citizen.packages."${ext.system}";
in {
  config = lib.mkIf (false) {
    home.packages = [
      (gamePkgs.rsi-launcher.override {
        location = "$HOME/.local/share/star-citizen";
        useUmu = true;
        enableGlCache = true;
        extraEnvVars = {};
        enforceWaylandDrv = true;
        launchCommand = "%command%";
      })
    ];
    home.allowedUnfree.packages = [ "star-citizen" ];
  };
}
