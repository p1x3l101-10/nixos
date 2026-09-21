{ lib
, runCommand
, symlinkJoin
, stdenvNoCC
, nushell
, makeWrapper
}:
lib.fix (finalLib: {
  renamePath = source: destination: runCommand "rename-path" {} ''
    mkdir -p "$out/$(dirname "${destination}")"
    cp -r "${source}" "$out/${destination}"
  '';
  mkNuModules = (
    { plainModules ? []
    , plainModuleFolders ? []
    , installedModules ? []
    }:
    lib.fix (final: (symlinkJoin {
      name = "nu-modules-merged";
      paths = (
        (map
          (x: finalLib.renamePath x "share/nushell/modules/${builtins.baseNameOf x}")
          plainModules
        ) ++ (map
          (x: finalLib.renamePath x "share/nushell/modules")
          plainModuleFolders
        ) ++ installedModules
      );
      passthru = {
        modulePath = "${final}/share/nushell/modules";
        # Run in installPhase
        patchScript = scriptPath: ''sed -i '2i\const NU_LIB_DIRS = $NU_LIB_DIRS ++ ["${final.modulePath}"]' ${scriptPath}'';
      };
    }))
  );
  mkNuScript = (
    { name
    , version ? "0.0.0"
    , packageDir
    , scriptName ? name
    , srcScriptName ? "main.nu"
    , packageDirFilter ? (file: ! file.hasExt "nix")
    , binaryPath ? []
    , extraBuildInputs ? []
    , nuModules ? null
    , preProcessInstallCommands ? "" # Run after script is installed, but before any wrapping
    , extraInstallCommands ? "" # Run after script is wrapped
    , meta ? {}
    , passthru ? {}
    }:
    let
      useModules = ! builtins.isNull nuModules;
    in
    stdenvNoCC.mkDerivation {
      inherit name version meta;

      src = lib.fileset.toSource {
        fileset = (lib.fileset.fileFilter packageDirFilter packageDir);
        root = packageDir;
      };

      nativeBuildInputs = [
        makeWrapper
      ];

      buildInputs = [
        nushell
      ] ++ binaryPath ++ extraBuildInputs ++ lib.optional useModules nuModules;

      installPhase = builtins.concatStringsSep "\n" (
        [ "install -Dm755 ${srcScriptName} $out/bin/${scriptName}" ]
        ++ [ preProcessInstallCommands ]
        ++ (lib.optional useModules (nuModules.patchScript "$out/bin/${scriptName}"))
        ++ (lib.optional (binaryPath != []) ''
          wrapProgram "$out/bin/${scriptName}" \
            --inherit-argv0 \
            --set PATH ${lib.makeBinPath binaryPath}
        '')
        ++ [ extraInstallCommands ]
      );
    }
  );
})
