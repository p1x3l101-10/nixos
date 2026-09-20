{ ext
, lib
, stdenvNoCC
, fetchItchIo
, makeWrapper
, p7zip
, umu-launcher
, proton-ge-bin
, makeDesktopItem
, copyDesktopItems
, stdenv ? stdenvNoCC
, winePrefix ? "~/.local/share/voicesofthevoid"
, protonPath ? "${proton-ge-bin.steamcompattool}/"
}:

stdenv.mkDerivation (final: {
  name = "voicesofthevoid";
  version = "a09n";

  src = fetchItchIo {
    name = "${final.version}.7z";
    hash = "sha256:4b80dacb0926d21d6650c6842e17785c3d9dbeaade5e2a3159346c39bba20799";
    gameUrl = "https://mrdrnose.itch.io/votv";
    upload = "1672704";
  };

  nativeBuildInputs = [
    p7zip
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    umu-launcher
  ];

  unpackPhase = ''
    7z x -y -r $src
  '';

  installPhase = ''
    mkdir -p $out/libexec

    cp -r "${final.version}/WindowsNoEditor" $out/libexec/voicesofthevoid

    mkdir -p $out/bin
    makeWrapper ${umu-launcher}/bin/umu-run $out/bin/${final.name} \
      --add-flags "$out/libexec/voicesofthevoid/VotV.exe" \
      --set STORE "itchio" \
      --set GAMEID "votv" \
      --set WINEPREFIX '${winePrefix}' \
      --set PROTONPATH "${protonPath}"
  '';

  desktopItem = makeDesktopItem {
    name = final.name;
    exec = "${final.name} %U";
    desktopName = "Voices of the Void";
    categories = ["Game"];
  };

  meta = with lib; {
    description = "Voices of the Void is an ambient horror survival game with sandbox game elements.";
    homepage = "https://mrdrnose.itch.io/votv";
  };
})
