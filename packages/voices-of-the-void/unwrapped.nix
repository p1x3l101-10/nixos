{ lib
, stdenvNoCC
, callPackage
, makeWrapper
, p7zip
, imagemagick
, umu-launcher
, proton-ge-bin
, makeDesktopItem
, winePrefix ? "~/.local/share/voicesofthevoid-unwrapped"
, protonPath ? "${proton-ge-bin.steamcompattool}/"
, votvData ? callPackage ./raw.nix {}
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
  imgSizes = builtins.concatStringsSep " " (map (x: builtins.toString x) info.build.iconSizes);
in stdenvNoCC.mkDerivation (final: {
  name = "voicesofthevoid-unwrapped";
  version = info.download.version;

  src = votvData;

  nativeBuildInputs = [
    p7zip
    imagemagick
    makeWrapper
  ];

  buildInputs = [
    umu-launcher
  ];

  buildPhase = ''
    7z e -y "WindowsNoEditor/VotV.exe" ".rsrc/ICON/4.ico"
    for size in ${imgSizes}; do
      magick -background none 4.ico -resize "''${size}x''${size}" "''${size}x''${size}.png"
    done
  '';

  installPhase = ''
    mkdir -p $out/libexec

    cp -r "WindowsNoEditor" $out/libexec/voicesofthevoid

    mkdir -p $out/bin
    makeWrapper ${umu-launcher}/bin/umu-run $out/bin/voicesofthevoid \
      --add-flags "$out/libexec/voicesofthevoid/VotV.exe" \
      --set STORE "${info.umu.store}" \
      --set GAMEID "${info.umu.gameId}" \
      --set WINEPREFIX '${winePrefix}' \
      --set PROTONPATH "${protonPath}"

    mkdir -p $out/share
    cp -r "${final.desktopItem}/share/applications" $out/share/applications

    mkdir -p $out/share/icons/hicolor
    for size in ${imgSizes}; do
      mkdir -p "''${out}/share/icons/hicolor/''${size}x''${size}/apps"
      cp "''${size}x''${size}.png" "''${out}/share/icons/hicolor/''${size}x''${size}/apps/voicesofthevoid.png"
    done
  '';

  desktopItem = makeDesktopItem {
    name = "voicesofthevoid";
    icon = "voicesofthevoid";
    exec = "voicesofthevoid %U";
    desktopName = "Voices of the Void";
    categories = ["Game"];
  };

  passthru.baseVotv = callPackage ./raw.nix {};

  meta = with lib; {
    description = "Voices of the Void is an ambient horror survival game with sandbox game elements.";
    homepage = "https://mrdrnose.itch.io/votv";
  };
})
