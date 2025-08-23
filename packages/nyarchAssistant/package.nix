{ lib
, pythonPkgs
, python-livepng
, python-wordllama
, rocmPackages
, webkitgtk_6_0
, ffmpeg
, fetchFromGitHub
, stdenv
, libadwaita
, python3
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, docutils
, desktopToDarwinBundle
, vte-gtk4
, dconf
, gobject-introspection
, gsettings-desktop-schemas
, adwaita-icon-theme
, gtksourceview5
, desktop-file-utils
, lsb-release
}:

let
  pythonDependencies = with pythonPkgs; [
    pygobject3
    libxml2
    requests
    pydub
    gtts
    (speechrecognition.override {
      # Why is triton being dumb here? why must there be two versions that packages want at the same time???
      openai-whisper = openai-whisper.override {
        triton = rocmPackages.triton;
      };
    })
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
    python-wordllama
  ];
in
stdenv.mkDerivation rec {
  pname = "nyarchassistant";
  version = "0.9.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "NyarchLinux";
    repo = "NyarchAssistant";
    tag = "1.0.0";
    hash = "sha256-7LFECMMEHrZnfyRfUPTLyt7sa9/8n4K2Bfr2ZLFrmMQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
    docutils
    wrapGAppsHook4
    desktop-file-utils
    pkg-config
  ] ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    libadwaita
    python3
    gobject-introspection
    vte-gtk4
    dconf
    adwaita-icon-theme
    gsettings-desktop-schemas
    gtksourceview5
    desktop-file-utils
    lsb-release
    webkitgtk_6_0
    ffmpeg
  ];

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
    gappsWrapperArgs+=(--set PYTHONPATH "${pythonPkgs.makePythonPath pythonDependencies}")
    patchShebangs $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/NyarchLinux/NyarchAssistant";
    description = "Nyarch Assistant - Your ultimate Waifu AI Assistant ";
    mainProgram = "nyarchassistant";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };

}
