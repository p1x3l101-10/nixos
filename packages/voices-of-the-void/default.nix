{ ext
, lib
, stdenvNoCC
, fetchurl
, makeWrapper
, p7zip
, imagemagick
, umu-launcher
, proton-ge-bin
, makeDesktopItem
, copyDesktopItems
, stdenv ? stdenvNoCC
, winePrefix ? "~/.local/share/voicesofthevoid"
, protonPath ? "${proton-ge-bin.steamcompattool}/"
}:

let
  verToUrl = x: builtins.concatStringsSep "" (builtins.splitVersion x);
  verToPath = x: "a09n"; # TODO: Find some pattern in pathnames and make a real function instead of hardcoding
in stdenv.mkDerivation (final: {
  name = "voicesofthevoid";
  version = "0.9.0n";

  src = fetchurl {
    # Thankfully, the dev pushes hashes alongside the builds
    # Find them at https://archive.votv.dev/games/votv/
    # NOTE: The url will process from the version name, no need to change that
    # NOTE2: Because this is base16 instead of nix-base32, be sure to prefix with `sha256:` instead of `sha256-`
    url = "https://r2.votv.dev/archive/votv/${verToUrl final.version}.7z";
    hash = "sha256:4B80DACB0926D21D6650C6842E17785C3D9DBEAADE5E2A3159346C39BBA20799";
  };

  nativeBuildInputs = [
    p7zip
    imagemagick
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    umu-launcher
  ];

  unpackPhase = ''
    7z x -y -r $src
    7z e -y "${verToPath final.version}/WindowsNoEditor/VotV.exe" ".rsrc/ICON/4.ico"
  '';

  buildPhase = ''
    for size in 16 24 32 48 64 256; do
      magick -background none 4.ico -resize "''${size}x''${size}" "''${size}x''${size}.png"
    done
  '';

  installPhase = ''
    mkdir -p $out/libexec

    cp -r "${verToPath final.version}/WindowsNoEditor" $out/libexec/voicesofthevoid

    mkdir -p $out/bin
    makeWrapper ${umu-launcher}/bin/umu-run $out/bin/${final.name} \
      --add-flags "$out/libexec/voicesofthevoid/VotV.exe" \
      --set STORE "itchio" \
      --set GAMEID "votv" \
      --set WINEPREFIX '${winePrefix}' \
      --set PROTONPATH "${protonPath}"

    mkdir -p $out/share
    cp -r "${final.desktopItem}/share/applications" $out/share/applications

    mkdir -p $out/share/icons/hicolor
    for size in 16 24 32 48 64 256; do
      mkdir -p "''${out}/share/icons/hicolor/''${size}x''${size}/apps"
      cp "''${size}x''${size}.png" "''${out}/share/icons/hicolor/''${size}x''${size}/apps/${final.name}.png"
    done
  '';

  desktopItem = makeDesktopItem {
    name = final.name;
    icon = final.name;
    exec = "${final.name} %U";
    desktopName = "Voices of the Void";
    categories = ["Game"];
  };

  meta = with lib; {
    description = "Voices of the Void is an ambient horror survival game with sandbox game elements.";
    homepage = "https://mrdrnose.itch.io/votv";
  };
})
