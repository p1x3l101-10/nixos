{ lib, ext, self }:

name: value:

if (value != null) then (
  self.attrsets.createAttr (lib.strings.toUpper name) (lib.strings.toUpper (builtins.toString value))
) else (
  {}
)