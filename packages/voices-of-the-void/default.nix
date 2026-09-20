{ ext
, lib
, stdenvNoCC
, fetchItchIo
, fetchUrl
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
  version = "0.9.0n";

  src = fetchUrl {
    # Thankfully, the dev pushes hashes alongside the builds
    # Find them at https://archive.votv.dev/games/votv/
    # NOTE: The url will process from the version name, no need to change that
    # NOTE2: Because this is base16 instead of nix-base32, be sure to prefix with `sha256:` instead of `sha256-`
    url = "https://r2.votv.dev/archive/votv/${builtins.concatStringsSep "" (builtins.splitVersion final.version)}.7z";
    hash = "sha256:4B80DACB0926D21D6650C6842E17785C3D9DBEAADE5E2A3159346C39BBA20799";
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

    mkdir -p $out/share
    cp -r "${final.desktopItem}/share/applications" $out/share/applications
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
