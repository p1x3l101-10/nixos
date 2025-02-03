{ lib
, inputs
}:

{
  mkNixPak = lib.nixpak.nixpak {
    # Only give nixpak nixpkgs things
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    lib = lib.nixpkgs;
  };
}
