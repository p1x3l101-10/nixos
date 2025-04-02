{ lib, ext }:

{ src, callPackage }:


  (
    lib.attrsets.mapAttrs (name: value:
      callPackage value { }
    ) (
      lib.internal.flake.genModules { inherit src; }
    )
  )