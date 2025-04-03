{ lib, ext, self }:

lib.nixpak.nixpak {
  # Only give nixpak nixpkgs things
  inherit (ext) pkgs;
  inherit lib;
}