{ lib, ext, self }:

{ stdenv ? ext.pkgs.stdenvNoCC
, libarchive ? ext.pkgs.libarchive
, rsync ? ext.pkgs.rsync
, name ? "genericPack"
, version ? "1"
, packList
}:

stdenv.mkDerivation rec {
  pname = "${name}-bundle";
  inherit version;
  srcs = packList;
  nativeBuildInputs = [
    rsync
    libarchive
  ];
  sourceRoot = ".";
  buildPhase = ''
    mkdir .work
    mkdir .work/mods
    touch .work/mods/.keep
    if [[ -e overrides ]]; then
      mv overrides zzz-overrides
    fi
    for pack in $(find . -maxdepth 1 -type d); do
      if [[ "$pack" != "." ]] && [[ "$pack" != "./.work" ]]; then
        rsync -rIcv --executability "$pack/" .work
        rm -rvf "./.work/$pack"
      fi
    done
    if [[ -e ./.work/eula.txt ]]; then
      rm -f ./.work/eula.txt
    fi
  '';
  installPhase = ''
    bsdtar -cvhf ./out.zip --format=zip --no-same-permissions --no-same-owner ./.work/*
    mv ./out.zip $out
    chmod 644 $out
  '';
}