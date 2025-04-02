{ lib, ext }:

{ packages
, namespace ? "internal"
}:

{
  nixpkgs.overlays = [final: prev: {
    "${namespace}" = packages;
  }];
}