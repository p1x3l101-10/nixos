{ ext
, lib
, stdenv
, fetchFromGitHub
, outlineColor ? "#FFFFFF"
, baseColor ? "#4D4D4D"
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
in stdenv.mkDerivation {
  name = "BreezeX_Cursor";
  inherit (info) version;

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "BreezeX_Cursor";
    inherit (info.src) rev hash;
  };

  passthru.updateScript = ./update.nu;
}
