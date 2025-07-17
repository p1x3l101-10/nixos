{ lib, ext, self }:

src: newScope: extraAutoArgs:

let
  scopeWithArgs = lib.makeScope newScope (_: extraAutoArgs);
in

lib.makeScope scopeWithArgs.newScope (self:
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
