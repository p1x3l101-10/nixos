{ lib, ext, self }:

let
  infuseLib = import ext.inputs.infuse {
    inherit lib;
    sugars = infuseLib.v1.default-sugars ++ lib.attrsToList {
      # Custom infusion sugars
    };
  };
in

infuseLib.v1.infuse
