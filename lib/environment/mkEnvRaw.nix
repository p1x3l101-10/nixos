{ lib, ext }:

name: value:

if (value != null) then (
  lib.internal.createAttr name value
) else (
  {}
)