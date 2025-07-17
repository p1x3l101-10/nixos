{ lib, ext, self }:

src: newScope: extraAutoArgs:

let
  newScopeWithArgs = lib.makeScope newScope (_: extraAutoArgs);
in

lib.makeScope newScopeWithArgs (self:
(
  lib.attrsets.mapAttrs
    (name: value:
    (self.callPackage value { })
    )
    (
      lib.attrsets.mapAttrs
        (name: _:
        src + "/${name}"
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
    )
)
)
