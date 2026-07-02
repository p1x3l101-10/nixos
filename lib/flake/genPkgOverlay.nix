{ lib, ext, self }:

{ packages, namespace }:

{ ... }: {
  nixpkgs.overlays = lib.mkAfter [
    (final: prev: {
      "${namespace}" = packages;
    })
  ];
}
