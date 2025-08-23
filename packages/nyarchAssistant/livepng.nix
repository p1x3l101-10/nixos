{ lib, pythonPkgs, fetchPypi, ... }:

pythonPkgs.buildPythonPackage (lib.fix (self: {
  pname = "livepng";
  version = "0.1.8";
  src = fetchPypi {
    pname = "livepng";
    inherit (self) version;
    hash = "sha256-PdfufkU2K+2kitMGKL21Ovj8semvLT6BfO9o5MIILPk=";
  };
  pyproject = true;
  build-system = with pythonPkgs; [ setuptools ];
  propagatedBuildInputs = with pythonPkgs; [
    pyaudio
    pydub
  ];
  meta = with lib; {
    homepage = "https://github.com/francescocaracciolo/livepng";
    description = "LivePNG is a format to create avatars based on PNG images with lipsync support";
    license = licenses.gpl3;
  };
}))
