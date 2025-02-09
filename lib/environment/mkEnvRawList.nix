{ lib, ext }:

name: value: seperator:

if (value != []) then (
  lib.internal.mkEnvRaw name (lib.concatStringsSep seperator value)
) else (
  {}
)