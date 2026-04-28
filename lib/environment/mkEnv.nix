{ lib, ext, self }:

name: value:

self.environment.mkEnvRaw (lib.strings.toUpper name) (lib.strings.toUpper (builtins.toString value))
