{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, p7zip
, imagemagick
, umu-launcher
, proton-ge-bin
, makeDesktopItem
, stdenv ? stdenvNoCC
, winePrefix ? "~/.local/share/voicesofthevoid-unwrapped"
, protonPath ? "${proton-ge-bin.steamcompattool}/"
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
  verToUrl = x: builtins.concatStringsSep "" (builtins.splitVersion x);
  imgSizes = builtins.concatStringsSep " " (map (x: builtins.toString x) info.build.iconSizes);
  # TODO: Find some pattern in pathnames and make a real function instead of hardcoding
  verToPath = x: info.build.fixmeHardcoded.verPath;
  # Shorten rebuild times with this
  fetchVotV = { version, sha256 }: stdenv.mkDerivation {
    name = "votv-source";
    inherit version;

    src = fetchurl {
      url = info.download.urlBase + "/" + (verToUrl version) + ".7z";
      hash = "sha256:${sha256}";
    };

    nativeBuildInputs = [ p7zip ];

    unpackPhase = ''
      7z x -y -r $src
    '';
    
    installPhase = ''
      cp -r "${verToPath version}" $out
    '';
  };
in stdenv.mkDerivation (final: {
  name = "voicesofthevoid-unwrapped";
  version = info.download.version;

  src = fetchVotV {
    inherit (info.download) version sha256;
  };

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

  meta = with lib; {
    description = "Voices of the Void is an ambient horror survival game with sandbox game elements.";
    homepage = "https://mrdrnose.itch.io/votv";
  };
})
