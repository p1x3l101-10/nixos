{ lib
, pythonPkgs
, python-livepng
, python-wordllama
, webkitgtk_6_0
, ffmpeg
, prompt-dataset
, writeText
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

  patches = [
    (writeText "fix-dataset-path.patch" ''
      diff --git a/src/dataset.py b/src/dataset.py
      index e9478f8..def0ea4 100644
      --- a/src/dataset.py
      +++ b/src/dataset.py
      @@ -221,6 +221,6 @@ ollama pull hf.co/{username}/{repository}
      if is_flatpak():
          dataset_path = "/app/data/smart-prompts/dataset.csv"
      else:
      -    dataset_path = "/usr/share/nyarchassistant/dataset.csv"
      +    dataset_path = "${prompt-dataset}"
      DATASET = reconstruct_dataset_from_csv(dataset_path)
    '')
  ];

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
