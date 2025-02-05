{ channels, self, nixpkgs, ... }:
let
  lib = nixpkgs.lib;
in
final: prev: {
  nix = prev.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      # Remove nix2 symlinks
      for bin in $out/bin/*; do
        if [[ "$(basename "$bin")" != "nix" ]] ; then
          rm -v "$bin"
        fi
      done
    '';
  });
}
