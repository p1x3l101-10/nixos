{ lib
, stdenv
, fetchFromGitHub
, nodejs
, gettext
, just
, glib
, zip
}:
let
  gitRev = "c0a59050857cd5a6ebf47dbaa6b77bf0530d405b";
in

stdenv.mkDerivation {
  pname = "gnomeExtension-roundedWindowCorners";
  version = "git-${gitRev}";

  src = fetchFromGitHub {
    owner = "flexagoon";
    repo = "rounded-window-corners";
    rev = gitRev;
    hash = "sha256-UhZOesz/L9n+/Qh/geR5e7rOjO75BPLcFLp4Gfgiuss=";
  };

  nativeBuildInputs = [
    nodejs
    gettext
    just
    glib.dev
    zip
  ];

  meta = with lib; {
    name = "rounded-window-corners";
    broken = true;
  };
}
