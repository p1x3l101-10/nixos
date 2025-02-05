{ channels, ... }:
let
  lib = channels.nixpkgs.lib;
in
final: prev: {
  nix = prev.nix.overrideAttrs (oldAttrs: {
    installPhase = lib.concatLines [
      oldAttrs.installPhase
      ''
        # Remove nix2 symlinks
        for bin in $out/bin/*; do
          if [[ "$(basename "$bin")" != "nix" && -L "$bin" ]] ; then
            rm -v "$bin"
          fi
        done
        # Fix nix-daemon.service to use `nix daemon`
        sed -i 's|^ExecStart=.*|ExecStart=@${prev.nix}/bin/nix daemon|' $out/lib/systemd/system/nix-daemon.service
      ''
    ];
  });
}
