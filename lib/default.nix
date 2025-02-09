{ lib, inputs, namespace, snowfall-inputs }:

let
  ext = import ./ext.nix { inherit lib inputs namespace snowfall-inputs; }; # Any extra configuration to be passed to the functions
  # Create temp callLib function and use it to pull in genLib
  c = f: import f { inherit lib ext; };
  genLib = s: a: c ./internal/genLib.nix c s a;
in 
genLib ./. [
  "internal" # Always first

  # No deps (other than internal)
  "attrsets"
  "builders"
  "conf-templates"
  "lists"

  # Has deps, must be ordered
  "environment" # Depends on `attrsets`
]