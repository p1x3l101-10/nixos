{ lib, ext, self }:
callLibPrimitive:

path:

let
  fn = callLibPrimitive path; # Import the function
  argCount = builtins.length (builtins.attrNames (builtins.functionArgs fn));
  # Create a minimal clone of self.lists.switch to avoid pulling in non-internal deps
  switch = c: d: (lib.lists.findFirst (builtins.getAttr "case") { } c).out or d;
in

callLibPrimitive path
