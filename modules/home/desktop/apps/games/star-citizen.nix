{ ext, osConfig, lib, ... }:

let
  gamePkgs = ext.inputs.nix-gaming.packages."${ext.system}";
in {
  config = lib.mkIf (osConfig.networking.hostName == "pixels-pc") {
    home.packages = [
      (gamePkgs.star-citizen.override {
        location = "$HOME/.local/share/star-citizen";
        useUmu = true;
        enableGlCache = true;
      })
    ];
    home.allowedUnfree.packages = [ "star-citizen" ];
  };
}
