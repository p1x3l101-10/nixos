{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

let
  version = "3.0.2";
  rc = "3";
in

stdenvNoCC.mkDerivation (self: {
  pname = "MusicPlayerPlus";
  version = version + "r" + rc;
  
  src = fetchurl {
    url = "https://github.com/doctorfree/MusicPlayerPlus/releases/download/v${version}r${rc}/MusicPlayerPlus_${version}-${rc}.zip";
    hash = "sha256-psIQ/uvWLS5KGI1GdHW6ag9+xoGESA6xjqIOVkcw76E=";
  };

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
    cp -r share $out/share
  '';

  meta = with lib; {
    licence = with licences; mit;
    homepage = "https://github.com/doctorfree/MusicPlayerPlus";
  };
})
