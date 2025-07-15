{ lib, ext, self }:

src: dirs:

self.callLibPrimitive ../internal-raw/genLib.nix self.getFunctionsFromDir src dirs
