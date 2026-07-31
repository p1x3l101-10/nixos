{ ext,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  xorg,
  libgcc,
  libGLU,
  glib,
  libXinerama,
  libxkbcommon,
  wayland,
  freetype,
  fontconfig,
  lib,
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
    xorg.libX11
    stdenv.cc.cc.lib
    libgcc
    xorg.libXfixes
    xorg.libXtst
    libGLU
    glib
    libXinerama
    libxkbcommon
    wayland
    freetype
    fontconfig
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
    ln -s $out/opt/HelpWire/Operator/bin $out/bin

    runHook postInstall
  '';
}
