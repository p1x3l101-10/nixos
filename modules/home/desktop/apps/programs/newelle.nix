{ ext, pkgs, lib, ... }:

let
  pythonPkgs = pkgs.python312Packages;
  python-livepng = pythonPkgs.buildPythonPackage (lib.fix (self: {
    pname = "livepng";
    version = "0.1.8";
    src = pkgs.fetchPypi {
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
  }));
  # Copied from flake
  pythonDependencies = with pkgs.python3.pkgs; [
    pygobject3
    libxml2
    requests
    pydub
    gtts
    speechrecognition
    numpy
    matplotlib
    newspaper3k
    lxml
    lxml-html-clean
    pylatexenc
    pyaudio
    tiktoken
    openai
    ollama
    llama-index-core
    llama-index-readers-file
    pip-install-test
    python-livepng
  ];
in {
  home.packages = [
    (ext.inputs.nyarchAssistant.packages.${ext.system}.newelle.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ (with pkgs; [
        webkitgtk_6_0
      ]);
      preFixup = ''
        glib-compile-schemas $out/share/gsettings-schemas/${oldAttrs.pname}-${oldAttrs.version}/glib-2.0/schemas
        gappsWrapperArgs+=(--set PYTHONPATH "${pkgs.python3.pkgs.makePythonPath pythonDependencies}")
        patchShebangs $out/bin
      '';
    }))
  ];
}
