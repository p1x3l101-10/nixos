{ lib, ext }:

{ packages, namespace }:

{
  nixpkgs.overlays = [(final: prev: {
    "${namespace}" = packages;
  })];
}