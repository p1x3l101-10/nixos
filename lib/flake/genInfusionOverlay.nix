{ lib, ext, self }:

{ src
, additionalArgs ? {}
}:

let
  callArgs = (
    { final
    , prev }:
    {
      inherit final prev;
    } // additionalArgs
  );
  mkInfusionOverlay = infuseInstructions: (final: prev: self.infusion.infuse prev infuseInstructions);
  callInfusion = path: mkInfusionOverlay (import path callArgs);
in

builtins.listToAttrs (map
  (
    { name
    , value
    }:
    {
      inherit name;
      value = callInfusion (src + "/${name}");
    }
  )
  (lib.attrsets.attrsToList
    (builtins.readDir src)
  )
)
