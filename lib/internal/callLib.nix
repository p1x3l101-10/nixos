{ lib, ext }:
callLibPrimitive:

path:

let
  fn = callLibPrimitive path;  # Import the function
  argCount = builtins.length (builtins.attrNames (builtins.functionArgs fn));
  # Create a minimal clone of lib.internal.lists.switch to avoid pulling in non-internal deps
  switch = c: d: (lib.lists.findFirst (lib.builtins.getAttr "case") {} c).out or d;
in

switch [
  { case = (argCount == 0); out = fn; }
  { case = (argCount == 1); out = a: fn a; }
  { case = (argCount == 2); out = a: b: fn a b; }
  { case = (argCount == 3); out = a: b: c: fn a b c; }
] (args: fn args)