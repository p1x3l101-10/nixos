{ ext, config, lib, options, ... }:

let
  # Toggle if we overwite pkgs, or let it handle itself
  dominate = true;

  inherit (lib) mkOption types;
  cfg = config.nixpkgs.infusion;
  rawPkgs = ext.rawPkgs {
    inherit (ext.inputs) nixpkgs;
    config = (ext.defaultNixpkgsConfig // cfg.config);
  };
in {
  options.nixpkgs = {
    infusion = {
      infusions = mkOption {
        description = "Infusions use for nixpkgs";
        type = with types; listOf attrs;
        default = [];
      };
      config = (options.nixpkgs.config // { description = "A clone of `nixpkgs.config`, however this is used by the infusion process when dominate is true because `nixpkgs.config` is guarded by an assertion"; });
    };
  };
  config = (
    if dominate then (
      {
        nixpkgs.pkgs = ext.lib.infusion.mkInfusedPkgs rawPkgs cfg.infusions;
      }
    ) else (
      {
        nixpkgs.overlays = (map
          (infusion: ext.lib.infusion.genOverlay infusion)
          cfg.infusions
        );
        nixpkgs.config = cfg.config;
      }
    )
  );
}
