{ lib, inputs, namespace }:

lib.fix (self:
let
  ext = import ./ext.nix { inherit lib inputs namespace; }; # Any extra configuration to be passed to the functions
  # Create temp callLib function and use it to pull in genLib
  c = f: import f { inherit lib ext self; };
  genLib = s: a: c ./internal-raw/genLib.nix c s a;
in 
genLib ./. [
  "internal" # Always first

  # No deps (other than internal)
  "attrsets"
  "builders"
  "confTemplates"
  "lists"

  # Has deps, must be ordered
  "environment" # Depends on `(attrsets) createAttr`
  "minecraft"
  "sss"

  # Last
  "flake"
])