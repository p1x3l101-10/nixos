{ lib, ext, self }:

name: value:

if (value != null) then (
  lib.internal.attrsets.createAttr (lib.strings.toUpper name) (lib.strings.toUpper (builtins.toString value))
) else (
  {}
)