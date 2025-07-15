{ lib, ext, self }:

dir:

self.callLibPrimitive ../internal-raw/getFunctionsFromDir.nix self.callLib dir
