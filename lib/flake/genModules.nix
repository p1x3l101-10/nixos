{ lib, ext, self }:

{ src }:

lib.attrsets.mapAttrs (name: _:
  src + "/${name}"
) (
  lib.attrsets.filterAttrs (_: type:
    type == "directory"
  ) (
    builtins.readDir src
  )
)