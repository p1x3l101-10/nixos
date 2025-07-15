{ lib, ext, self }:

{ packages, namespace }:

{ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      "${namespace}" = packages;
    })
  ];
}
