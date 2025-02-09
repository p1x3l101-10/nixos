{ lib, ext }:

name: value: seperator:

if (value != []) then (
  lib.internal.mkEnvRaw (lib.toUpper name) (lib.toUpper(lib.concatStringsSep seperator value))
) else (
  {}
)