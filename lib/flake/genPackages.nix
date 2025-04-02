{ lib, ext }:

{ src, newScope }:

lib.makeScope newScope (self:
  (
    lib.attrsets.mapAttrs (name: value:
      import value { }
    ) (
      lib.internal.flake.genModules { inherit src; }
    )
  )
)