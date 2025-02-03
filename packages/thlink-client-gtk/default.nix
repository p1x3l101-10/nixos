{ lib
, buildGoModule
, gtk3
, glib
, atk
, zlib
, fetchFromGitHub
}:

buildGoModule rec {
  meta = with lib; {
    description = "Touhou Project Game Netplay Tool";
    homepage = "https://github.com/weilinfox/youmu-thlink";
    licence = licences.agpl3Only;
    broken = true; # GO is too new
  };

  pname = "thlink-client-gtk";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "weilinfox";
    repo = "youmu-thlink";
    rev = "v${version}";
    hash = "sha256-E+M8GitLpB8ZoEm6rhAkKF4Nc2o0VnsLjZat25w5lNA=";
  };

  vendorHash = "sha256-wORQ1aoZzDwxLlfvDFcAexnyGwVuZDwTYHV9pfhFS5U=";

  buildInputs = [
    gtk3
    glib
  ];

  nativeBuildInputs = [
    gtk3
    glib
    atk
    zlib
  ];

  installPhase = ''
    install -Dm755 ./build/thlink-client-gtk $out/usr/bin/thlink-client-gtk
    install -Dm755 ./thlink-client-gtk.desktop $out/usr/share/applications/thlink-client-gtk.desktop
    install -Dm644 ./thlink-client-gtk.png $out/usr/share/icons/hicolor/32x32/apps/thlink-client-gtk.png
  '';
}
