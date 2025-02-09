{ lib, ext }:

name: value:

if (value != null) then (
  lib.internal.attrsets.createAttr (lib.strings.toUpper name) (builtins.toString value)
) else (
  {}
)