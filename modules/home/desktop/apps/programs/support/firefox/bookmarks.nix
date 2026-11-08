{ osConfig, lib, ext, ... }: # Needed so that the version of nix is tracked

let
  trimSemanticPatch = version: maxPlaces: builtins.addErrorContext "While trimming SemVer" (builtins.concatStringsSep "."
    (lib.lists.take
      maxPlaces
      (builtins.splitVersion version)
    )
  );
in import ./bookmarks.raw.nix {
  inherit (ext.lib.firefox) transcribeBookmarks;
  nixManualVersion = trimSemanticPatch osConfig.nix.package.version 2;
  nixosManualUrl = "file://${osConfig.system.build.manual.manualHTML}/share/doc/nixos/index.html";
}
