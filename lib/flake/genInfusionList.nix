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

map (x: callInfusion (src + "/${x.name}")) (lib.attrsets.attrsToList (builtins.readDir src))
