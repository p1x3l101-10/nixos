{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, name
, version
, file
}:

stdenv.mkDerivation rec {
  inherit name version;
  src = file;
  sourceRoot = ".";
  unpackPhase = ''
    cp ${src} "./${src.name}"
  '';
  buildPhase = ''
    mkdir -p mods
    mv ${src.name} "./mods/${src.name}"
  '';
  installPhase = ''
    mkdir -p $out
    mv mods $out/mods
  '';
}