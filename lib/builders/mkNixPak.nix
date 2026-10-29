{ lib, ext, self }:

self.builders.mkNixPak' ext.pkgs
