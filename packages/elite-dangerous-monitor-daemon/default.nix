{ lib
, ext
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, python3
, gir-rs
, gtk4
, imagemagick
}:

let
  common = lib.fix (final: {
    pname = "elite-dangerous-monitor-daemon";
    upcaseName = "Elite Dangerous Monitor Daemon";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "Maldor";
      repo = "EDMD";
      tag = "v${final.version}";
      hash = "sha256-jviTRZIWrxqXmCnkrWwtl0jzm5oJy95MK3eohUf+4BI=";
    };
  });

  pythonEnv = python3.withPackages (ps: with ps; [
    psutil
    pygobject3
    discord-webhook
    cryptography
  ]);

  libexec = "$out/libexec/${common.pname}";
in stdenv.mkDerivation (final: {
  inherit (common) pname version src;

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];

  buildInputs = [
    gir-rs
    gtk4
  ];

  installPhase = (
    ''
      # Setup
      mkdir -p $out/bin
      mkdir -p $out/share/EDMD
      mkdir -p $out/libexec
  
      # Installation
      cp -r ${final.src} ${libexec}
      ln -s ${libexec}/example.config.toml $out/share/EDMD/example.config.toml
      chmod +x ${libexec}/edmd.py
  
      # Icons
    '' + 
    (builtins.concatStringsSep "\n"
      (map
        (scale: ''
          mkdir -p $out/share/icons/hicolor/${scale}/app
          magick ${libexec}/images/edmd_avatar_4096.png -resize ${scale} $out/share/icons/hicolor/${scale}/app/${common.pname}.png
        '')
        (map
          (x: "${builtins.toString x}x${builtins.toString x}")
          [ # Scales to generate icons for
            16
            24
            32
            48
            64
            96
            128
            160
            192
            256
            512
          ]
        )
      )
    ) + "\n" +
    ''
      # Wrappers
      makeWrapper ${libexec}/edmd.py $out/bin/edmd --prefix PATH : "${pythonEnv}/bin" --set PYTHON_ENV_EXECUTABLE "${pythonEnv}/bin/python" --chdir ${libexec}
    ''
  );

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
    name = common.pname;
    desktopName = common.upcaseName;
    exec = "edmd --gui";
    icon = common.pname;
    keywords = [
      "elite" "dangerous"
      "edmd"
      "management"
    ];
  });

  meta = with lib; {
    description = "Elite Dangerous Monitoring Daemon";
    platforms = platforms.linux;
  };
})
