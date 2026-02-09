{ lib
, stdenvNoCC
, symlinkJoin
, writers
, globals
}:

let
  inherit (globals.server) dns;
  inherit (writers) writeTOML;
  config = writers.writeTOML "config.toml" (import ./webpage-cfg.nix { inherit globals; });
  renameFile = input: destPath: stdenvNoCC.mkDerivation {
    name = "${input.name}-renamed";
    src = input;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p "$out/${destPath}"
      rmdir "$out/${destPath}"
      ln -s "${input}" "$out/${destPath}"
    '';
  };
in

symlinkJoin {
  name = "preprocessed-webpage";
  paths = [
    ./webpage
    (renameFile config "config.toml")
  ];
}
