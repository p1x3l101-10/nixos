{ lib, ext, self }:

src: newScope: extraArgs:

lib.makeScope newScope (self:
(
  lib.attrsets.mapAttrs
    (name: value:
    (self.callPackage value extraArgs)
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
