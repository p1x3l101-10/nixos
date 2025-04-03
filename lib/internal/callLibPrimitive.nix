{ lib, ext, self }:

file:

(import ../internal-raw/callLibPrimitive.nix { inherit lib ext; }) file