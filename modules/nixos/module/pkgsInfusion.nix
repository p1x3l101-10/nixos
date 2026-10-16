{ ext, config, lib, ... }:

let
  inherit (lib) mkOption types mkIf;
  rawPkgs = ext.rawPkgs {
    inherit (ext.inputs) nixpkgs;
    config = (ext.defaultNixpkgsConfig // config.nixpkgs.config);
  };
in {
  options.nixpkgs.infusions = mkOption {
    description = "Infusions use for nixpkgs";
    type = with types; listOf attrs;
    default = [];
  };
  config = mkIf (config.nixpkgs.infusions != []) {
    nixpkgs.pkgs = ext.lib.infusion.mkInfusedPkgs rawPkgs config.nixpkgs.infusions;
  };
}
