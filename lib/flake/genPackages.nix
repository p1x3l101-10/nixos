{ lib, ext }:

{ src, newScope, genModules ? lib.internal.flake.genModules }:

lib.makeScope newScope (self:
  (
    lib.attrsets.mapAttrs (name: value:
      self.callPackage value { }
    ) (
      genModules { inherit src; }
    )
  )
)