{ callPackage
, python313Packages
, fetchPypi
, lib
, extraPrompts ? [] # Array of { prompt = ""; label = ""; }
, ...
}:

let
  pythonPkgs = python313Packages;
  callSubPkg = file: import file { inherit lib pythonPkgs fetchPypi; };
  python-livepng = callSubPkg ./livepng.nix;
  python-wordllama = callSubPkg ./wordllama.nix;
  prompt-dataset = callPackage ./prompt-dataset.nix { inherit extraPrompts; };
in

callPackage ./package.nix {
  inherit python-livepng python-wordllama pythonPkgs prompt-dataset;
  python3 = pythonPkgs.python;
}
