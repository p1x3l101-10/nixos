{ lib, ext, self }:

{ src
, additionalArgs ? {}
}:

let
  callArgs = (
    {} // additionalArgs
  );
  callInfusion = path: (import path callArgs);
in

builtins.listToAttrs (map
  (x: 
    {
      inherit (x) name;
      value = callInfusion (src + "/${x.name}");
    }
  )
  (lib.attrsets.attrsToList
    (builtins.readDir src)
  )
)
