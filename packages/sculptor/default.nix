{ lib
, rustPlatform
, stdenv
, buildEnv
, fetchFromGitHub
, makeWrapper
, pkg-config
, openssl
}:

let
  sculptor-bin = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "sculptor-bin";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "shiroyashik";
      repo = finalAttrs.pname;
      tag = "v${finalAttrs.version}";
      hash = "sha256-+Jqvxi1v09g686A6bJ+mI6tp9WSYpHSU0MD8j1chV54=";
    };

    buildInputs = [
      openssl
    ];

    nativeBuildInputs = [
      openssl.dev
      pkg-config
    ];

    cargoHash = "sha256-7dQK4tpkRgWojsNWAjxBY/ftlGByRnlwa+apBTnmJVc=";

    # There are no tests
    doCheck = false;

    meta = with lib; {
      name = "Sculptor";
      description = "Unofficial backend V2 for minecraft mod Figura";
      homepage = "https://github.com/shiroyashik/sculptor?";
      changelog = "https://github.com/shiroyashik/sculptor/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.gpl3;
      mainProgram = "sculptor";
      platforms = lib.platforms.unix;
    };
  });
  sculptor-data = stdenv.mkDerivation (finalAttrs: {
    pname = "sculptor-data-files";
    inherit (sculptor-bin) version src;
    installPhase = ''
      mkdir -p $out/share/factory/etc/sculptor $out/bin
      cp ${finalAttrs.src}/Config.example.toml $out/share/factory/etc/sculptor/Config.toml
      touch $out/bin/split
    '';
  });
in

buildEnv {
  name = "sculptor";
  paths = [
    sculptor-bin
    sculptor-data
  ];
  buildInputs = [
    makeWrapper
  ];
  postBuild = ''
    rm $out/bin/split
    wrapProgram $out/bin/sculptor \
        --set RUST_CONFIG "/etc/sculptor/Config.toml" \
        --set ASSETS_FOLDER "/var/lib/sculptor/assets" \
        --set AVATARS_FOLDER "/var/lib/sculptor/avatars" \
        --set LOGS_FOLDER "/var/log/sculptor"
  '';
}
