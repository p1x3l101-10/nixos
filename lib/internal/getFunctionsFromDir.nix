{ lib, ext, self }:

dir:

lib.internal.callLibPrimitive ../internal-raw/getFunctionsFromDir.nix lib.internal.callLib dir