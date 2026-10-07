{ lib
, stdenvNoCC
, fetchurl
, p7zip
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
in

stdenvNoCC.mkDerivation (final: {
  name = "votv-source";
  version = info.download.version;

  src = fetchurl {
    url = info.download.url;
    hash = "sha256:${info.download.sha256}";
  };

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    7z x -y -r $src
  '';
    
  installPhase = ''
    cp -r "$(find . -mindepth 1 -print -quit)" $out
  '';
})
