{ lib, ext, self }:

name: value:

self.environment.mkEnvRaw (lib.strings.toUpper name) value
