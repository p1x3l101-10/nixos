{ lib, ext, self }:

name: value: seperator:

if (value != []) then (
  lib.internal.environment.mkEnvRaw name (lib.strings.concatStringsSep seperator (lib.forEach value (x: builtins.toString x)))
) else (
  {}
)