{ lib, ext }:

{ src, newScope }:

lib.makeScope newScope (self:
  (
    lib.attrsets.mapAttrs (name: value:
      self.callPackage value { }
    ) (
      lib.internal.flake.genModules { inherit src; }
    )
  )
)