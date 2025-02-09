{ lib, ext }:

name: value: seperator:

if (value != []) then (
  lib.internal.attrsets.mkEnvRaw (lib.strings.toUpper name) (lib.strings.toUpper (lib.strings.concatStringsSep seperator value))
) else (
  {}
)