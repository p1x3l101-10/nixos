{ lib, ext, self }:

pkgs:

ext.inputs.nixpak.lib.nixpak {
  # Only give nixpak nixpkgs things
  inherit pkgs;
  inherit (pkgs) lib;
}
