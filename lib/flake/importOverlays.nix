{ lib, ext, self }:

{ overlays }:


{ ... }: {
  nixpkgs = { inherit overlays; };
}
