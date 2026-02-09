{ lib
, stdenvNoCC
, callPackage
, globals
, zola
}:

let
  stdenv = stdenvNoCC;
in

stdenv.mkDerivation {
  name = "zola-build";
  src = callPackage ./source.nix { inherit globals; };
  nativeBuildInputs = [
    zola
  ];
  buildPhase = ''
    zola build
  '';
  installPhase = ''
    mv public $out
  '';
}
