{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, wayland
, cmake
, libxml
}:

stdenv.mkDerivation rec {
  name = "zwin";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zwin-project";
    repo = "zwin";
    tag = "v" + version;
    hash = "sha256-nQuYIa4m/sufyRCszUThebyBXJ7uB7k4HS1TRUjKV7s=";
  };

  buildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    cmake
    xml
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