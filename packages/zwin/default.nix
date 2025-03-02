{ lib
, stdenv
, fetchFromGithub
, meson
, ninja
, meson
, ninja
, pkgconfig
, wayland-scanner
, wayland
}:

stdenv.mkDerivation {
  name = "zwin";
  version = "0.1.0";

  src = fetchFromGithub {
    owner = "zwin-project";
    repo = "zwin";
  };

  buildInputs = [
    meson
    ninja
    pkgconfig
    wayland-scanner
  ];
  nativeBuildInputs = [
    wayland
  ];

  meta = with lib; {
    description = "XR Windowing System on top of Wayland";
    homepage = "https://github.com/zwin-project/zwin";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}