{ ext,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libgcc,
  libGLU,
  glib,
  libXinerama,
  libxkbcommon,
  wayland,
  freetype,
  fontconfig,
  lib,
  libx11,
  libxfixes,
  libxtst,
  udev,
  qt5
}:
stdenv.mkDerivation rec {
  name = "helpwire-operator";
  pname = name;
  version = "2.2";
  meta = with lib; {
    description = "A remote desktop access app to be used with the HelpWire web app.";
    homepage = "https://helpwire.app";
    license = licenses.unfreeRedistributable;
    mainProgram = "helpwire-operator";
    platforms = [
      "x86_64-linux"
    ];
    inherit version;
  };
  src = fetchurl {
    url = "https://www.helpwire.app/downloads/operator/linux/helpwire-operator.deb";
    sha256 = "sha256-Ga5yPXti0kuujJSggtMDxZhJAglU3UbV9hOP8Qs33W0=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    libx11
    stdenv.cc.cc.lib
    libgcc
    libxfixes
    libxtst
    libGLU
    glib
    libXinerama
    libxkbcommon
    wayland
    freetype
    fontconfig
    udev
    qt5.qtbase
    qt5.qtwayland
    qt5.qtx11extras
  ];
  unpackPhase = "dpkg-deb -x $src .";
  postUnpack = ''
    patchelf --ignore-missing libpng16.so.16 $sourceRoot/opt/HelpWire/Operator/lib/libQt5Gui.so.5
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    mv usr/share/doc $out/share/doc
    mv etc $out/etc
    mv opt $out/opt
    rm -v $out/opt/HelpWire/Operator/lib/libQt5{Core,DBus,Gui,Widgets,X11Extras,XcbQpa}.so.5
    for lib in "${qt5.qtwayland}/lib/libQt5WaylandClient.so.5" "${qt5.qtbase.out}/lib/libQt5XcbQpa.so.5"; do
      ln -vs $lib $out/opt/HelpWire/Operator/lib
    done
    ln -s $out/opt/HelpWire/Operator/bin $out/bin

    mkdir -p $out/share/applications
    ln -vs $out/opt/HelpWire/Operator/desktop/helpwire-operator.desktop $out/share/applications/helpwire-operator.desktop
    for size in 16 24 32 48 64 96 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      ln -vs $out/opt/HelpWire/Operator/desktop/helpwire-operator_''${size}.png $out/share/icons/hicolor/''${size}x''${size}/apps/helpwire-operator.png
    done

    runHook postInstall
  '';

  preFixup = ''
    wrapQtApp "$out/opt/HelpWire/Operator/bin/helpwire-operator"
  '';
}
