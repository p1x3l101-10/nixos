{ lib, ext }:

{ src, newScope }:

lib.makeScope newScope (self:
  lib.attrsets.mapAttrs (name: _:
    self.callPackage (src + "/" + name) {} # Package
  ) (
    lib.attrsets.filterAttrs (_: type: # filter the dirs
      type == "directory"
    ) (
      builtins.readDir src
    )
  )
)