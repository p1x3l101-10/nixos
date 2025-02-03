{ channels, ... }:

final: prev: {
  gpu-screen-recorder-gtk = prev.gpu-screen-recorder-gtk.overrideAttrs (oldAttrs: rec {
    # Prepend installing the icons to the package
    installPhase = channels.nixpkgs.lib.concatLines [
      oldAttrs.installPhase
      "cp -r icons $out/share"
    ];
  });
}
