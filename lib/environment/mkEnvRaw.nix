{ lib, ext, self }:

name: value:

let
  inherit (self.environment) mkEnvString;
in

if (value != null) then
  (
    self.attrsets.createAttr (mkEnvString name) (mkEnvString value)
  ) else
  (
    { }
  )
