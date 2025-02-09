{ lib, ext }:

name: value: seperator:

if (value != []) then (
  lib.internal.attrsets.mkEnvRaw (lib.strings.toUpper name) (lib.strings.concatStringsSep seperator (builtins.toString value))
) else (
  {}
)