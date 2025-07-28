{ lib, ext, self }:

src: newScope: extraArgs:

builtins.removeAttrs
  (
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
  ) [
  # Remove the scope vars that break packages
  "callPackage"
  "newScope"
  "overrideScope"
  "packages"
]
