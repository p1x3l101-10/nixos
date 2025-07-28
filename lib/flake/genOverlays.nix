{ lib, ext, self }:

{ src }:

lib.attrsets.mapAttrs
  (name: _:
  import (src + "/${name}") ext
  )
  (
    lib.attrsets.filterAttrs
      (_: type:
      type == "directory"
      )
      (
        builtins.readDir src
      )
  )
