{ lib, ext, self }:

src: newScope: extraArgs:

# This converts a directory tree into legacyPackages tree
# Any directory will be scanned, if it has `default.nix`, it is a package, otherwise it will be treated as a new package set
let
  recursiveCall = basePath: scope: (lib.makeScope
    scope
    (self: lib.attrsets.mapAttrs
      (_: value:
        if (builtins.isAttrs value) then value else (
          self.callPackage value extraArgs
        )
      )
      (lib.attrsets.mapAttrs
        (name: _:
          if (builtins.hasAttr "default.nix" (builtins.readDir (basePath + "/${name}"))) then (
            basePath + "/${name}"
          ) else (
            recursiveCall (basePath + "/${name}") self.newScope
          )
        )
        (lib.attrsets.filterAttrs
          (_: type: type == "directory")
          (builtins.readDir basePath)
        )
      )
    )
  );
in

recursiveCall src newScope
