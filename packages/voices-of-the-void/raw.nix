{ lib
, stdenvNoCC
, fetchurl
, p7zip
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
  verToUrl = x: builtins.concatStringsSep "" (builtins.splitVersion x);
  # TODO: Find some pattern in pathnames and make a real function instead of hardcoding
  verToPath = x: info.build.fixmeHardcoded.verPath;
in

stdenvNoCC.mkDerivation (final: {
  name = "votv-source";
  version = info.download.version;

  src = fetchurl {
    url = info.download.urlBase + "/" + (verToUrl final.version) + ".7z";
    hash = "sha256:${info.download.sha256}";
  };

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    7z x -y -r $src
  '';
    
  installPhase = ''
    cp -r "${verToPath final.version}" $out
  '';
})
