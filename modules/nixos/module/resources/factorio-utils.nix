# This file provides a top-level function that will be used by both nixpkgs and nixos
# to generate mod directories for use at runtime by factorio.
{ lib, stdenv }:
let
  inherit (lib)
    flatten
    head
    optionals
    optionalString
    removeSuffix
    replaceStrings
    splitString
    unique
    ;
in
{
  mkModDirDrvSettings =
    mods: modsDatFile: enabledMods: # a list of mod derivations # and the list of enabled mods (space age go crazy)
    let
      recursiveDeps = modDrv: [ modDrv ] ++ map recursiveDeps modDrv.deps;
      modDrvs = unique (flatten (map recursiveDeps mods));
      enabledModsJson = if (enabledMods != null)
      then 
        builtins.toFile "mods-list.json" (builtins.toJSON enabledMods)
      else
        builtins.toFile "mods-list.json" (builtins.toJSON {});
    in
    stdenv.mkDerivation {
      name = "factorio-mod-directory";

      preferLocalBuild = true;
      buildCommand =
        ''
          mkdir -p $out
          for modDrv in ${toString modDrvs}; do
            # NB: there will only ever be a single zip file in each mod derivation's output dir
            ln -s $modDrv/*.zip $out
          done
        ''
        + (optionalString (modsDatFile != null) ''
          cp ${modsDatFile} $out/mod-settings.dat
        '')
        + (optionalString (enabledMods != null) ''
          cp ${enabledModsJson} $out/mods-list.json
        '');
    };

  modDrv =
    { allRecommendedMods, allOptionalMods }:
    {
      src,
      name ? null,
      deps ? [ ],
      optionalDeps ? [ ],
      recommendedDeps ? [ ],
    }:
    stdenv.mkDerivation {

      inherit src;

      # Use the name of the zip, but endstrip ".zip" and possibly the querystring that gets left in by fetchurl
      name = replaceStrings [ "_" ] [ "-" ] (
        if name != null then name else removeSuffix ".zip" (head (splitString "?" src.name))
      );

      deps =
        deps ++ optionals allOptionalMods optionalDeps ++ optionals allRecommendedMods recommendedDeps;

      preferLocalBuild = true;
      buildCommand = ''
        mkdir -p $out
        srcBase=$(basename $src)
        srcBase=''${srcBase#*-}  # strip nix hash
        srcBase=''${srcBase%\?*} # strip querystring leftover from fetchurl
        cp $src $out/$srcBase
      '';
    };
}