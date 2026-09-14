{ lib
, runCommand
, symlinkJoin
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
})
