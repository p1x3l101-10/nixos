{ infuse, ... }:

let
  packages = [
    "lib2geom"
    "assimp"
  ];
in

final: prev: infuse prev (builtins.listToAttrs
  (map
    (pkg:
      {
        name = pkg;
        value.__output.__contentAddressed.__assign = false;
      }
    )
    packages
  )
)
