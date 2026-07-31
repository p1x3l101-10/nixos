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
    qt5.qt3d
    qt5.wrapQtAppsHook
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
    ln -s $out/opt/HelpWire/Operator/bin $out/bin

    runHook postInstall
  '';
}
