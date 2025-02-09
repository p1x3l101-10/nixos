{ lib, ext }:

name: value:

if (value != null) then (
  lib.internal.createAttr (lib.strings.toUpper name) (lib.strings.toUpper value)
) else (
  {}
)