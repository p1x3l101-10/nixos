{ lib, ext, self }:

src: newScope:

lib.makeScope newScope (self:
  (
    lib.attrsets.mapAttrs (name: value:
      (self.callPackage value { })
    ) (
      lib.attrsets.mapAttrs (name: _:
        src + "/${name}"
      ) (
        lib.attrsets.filterAttrs (_: type:
          type == "directory"
        ) (
          builtins.readDir src
        )
      )
    )
  )
)