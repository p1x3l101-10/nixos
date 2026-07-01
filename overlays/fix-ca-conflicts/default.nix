let
  packages = [
    "lib2geom"
    "assimp"
  ];
in
final: prev: (map
  (x:
    x.overrideAttrs (oldAttrs: {
      __contentAddressed = false;
    })
  )
  packages
)
