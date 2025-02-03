{ lib
, python312Packages
, stdenvNoCC
, fetchFromGitHub
}:


stdenvNoCC.mkDerivation rec {
  meta = with lib; {
    description = "Turns your Android device into a customizable gamepad for Windows/Mac/Linux ";
    homepage = "https://github.com/rmst/yoke";
    licence = licences.mit;
    broken = true; # Python app wont see its own lib
  };

  pname = "yoke";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "rmst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/pP6vdeFzAMbrF1tI0IcIYy4dLrvDWrtonbBxUE/2z8=";
  };

  installPhase = ''
    mkdir -p $out/lib/python3.12/site-packages
    mv bin $out
    mv yoke $out/lib/python3.12/site-packages
    chmod +x $out/bin/*
  '';

  propagatedBuildInputs = with python312Packages; [
    numpy
    zeroconf
    python-uinput
  ];
}
