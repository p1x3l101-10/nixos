{ ext, ... }:

final: prev: {
  inherit (ext.inputs.nixpkgs-unstable.legacyPackages.${ext.system})
    ashell
  ;
}
