{ lib, ext }:

src: dirs:

lib.internal.callLibPrimitive ../internal-raw/genLib.nix lib.internal.getFunctionsFromDir src dirs