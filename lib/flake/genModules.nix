{ lib, ext }:

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