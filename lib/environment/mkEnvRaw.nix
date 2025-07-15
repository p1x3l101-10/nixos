{ lib, ext, self }:

name: value:

if (value != null) then
  (
    self.attrsets.createAttr (lib.strings.toUpper name) (builtins.toString value)
  ) else
  (
    { }
  )
