{ lib
, inputs
, ...
}:

{
  buildFirefoxXpiAddon = lib.makeOverridable (
    { stdenv ? inputs.nixpkgs.legacyPackages.x86_64-linux.stdenvNoCC
    , fetchurl ? inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl
    , pname
    , version
    , addonId
    , url
    , sha256
    , meta ? { }
    , ...
    }:

    stdenv.mkDerivation {
      inherit pname version meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = { inherit addonId; };
      outputs = [ "out" "xpi" ];

      buildCommand = ''
        install -v -m644 "$src" "$xpi"
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    }
  );
}
