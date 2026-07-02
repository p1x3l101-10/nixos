{ ext, ... }:

let
  gamePkgs = ext.inputs.nix-gaming.packages."${ext.system}";
in {
  home.packages = [
    (gamePkgs.osu-lazer-bin.override {
      releaseStream = "lazer";
      gmrun_enable = true;
      pipewire_latency = "16/44000";
    })
  ];
  home.allowedUnfree.packages = [ "osu-lazer-bin" ];
}
