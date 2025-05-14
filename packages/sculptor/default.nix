{ lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sculptor";
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
    makeWrapper
    openssl.dev
    pkg-config
  ];

  postInstallPhase = ''
    wrapProgram $out/bin/sculptor \
      --set RUST_CONFIG "/etc/sculptor/Config.toml" \
      --set ASSETS_FOLDER "/var/lib/sculptor/assets" \
      --set AVATARS_FOLDER "/var/lib/sculptor/avatars" \
      --set LOGS_FOLDER "/var/log/sculptor"
  '';

  cargoHash = "sha256-N7j0zKeCrBw6PzfXYnHfn/4Q29bMOzfeWaKrf9ZzZPk=";

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
})