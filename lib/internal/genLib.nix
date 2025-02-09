{ lib, ext }:
callLibPrimitive:

src: libraryArray:

let
  # Helper to determine function arity and wrap appropriately
  callLib = a: callLibPrimitive ./callLib.nix a;
  # Helper to get all .nix files in a directory
  getFunctionsFromDir = a: callLibPrimitive ./getFunctionsFromDir.nix callLib a;
  # Process each directory in libraryArray
  buildLibrary = a: callLibPrimitive ./buildLibrary.nix getFunctionsFromDir src a;
in
buildLibrary libraryArray
