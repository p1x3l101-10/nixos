{ ext
, lib
, stdenv ? stdenvNoCC
, stdenvNoCC
, nushell
}:

stdenv.mkDerivation {
  name = "minecraft-helper";
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
  ];

  installPhase = ''
    mkdir -p $out/bin
    #mkdir -p $out/share/nushell/modules

    #cp -r minecraftWrapper $out/share/nushell/modules
    cp mc.nu $out/bin/mc
    chmod +x $out/bin/mc

    #substituteInPlace $out/bin/mc \
    #  --replace-fail "use minecraftWrapper" "use $out/share/nushell/modules/minecraftWrapper"
  '';
}
