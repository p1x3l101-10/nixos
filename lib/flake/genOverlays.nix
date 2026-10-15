{ lib, ext, self }:

{ src
, additionalOverlayArgs ? {}
}:

let
  overlayArgs = ({
    inherit (self.infusion) infuse;
  } // additionalOverlayArgs);
  callOverlay = path: import path overlayArgs;
in


builtins.listToAttrs (map
  (
    { name
    , value
    }:
    {
      inherit name;
      value = callOverlay (src + "/${name}");
    }
  )
  (lib.attrsets.attrsToList
    (builtins.readDir src)
  )
)
