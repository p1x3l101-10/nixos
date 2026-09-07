{ ext
, lib
, stdenv ? stdenvNoCC
, stdenvNoCC
, callPackage
, nushell
}:

let
  inherit (callPackage ./libs.nix {}) mkNuModules;
  #nuModules = mkNuModules { plainModules = [ ./scheduleHelper ]; };
in
stdenv.mkDerivation (finalDrv: {
  name = "mc";
  version = "0.0.0";

  src = (
    let
      fs = lib.fileset;
    in (
      fs.toSource {
        fileset = (fs.fileFilter (file: ! file.hasExt "nix") ./.);
        root = ./.;
      }
    )
  );

  buildInputs = [
    nushell
    #nuModules
  ];

  installPhase = ''
    install -Dm755 main.nu $out/bin/${finalDrv.name}
  '';
  # ${nuModules.patchScript "$out/bin/${finalDrv.name}"}
})
