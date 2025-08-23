{ callPackage
, python313Packages
, fetchPypi
, lib
}:

let
  pythonPkgs = python313Packages;
  callSubPkg = file: import file { inherit lib pythonPkgs fetchPypi; };
  python-livepng = callSubPkg ./livepng.nix;
  python-wordllama = callSubPkg ./wordllama.nix;
in

callPackage ./package.nix {
  inherit python-livepng python-wordllama pythonPkgs;
  python3 = pythonPkgs.python;
}
