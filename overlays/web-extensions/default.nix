{ channels
, self
, ...
}:

final: prev: {
  web-extensions = channels.nixpkgs.lib.recurseIntoAttrs (
    channels.nixpkgs.callPackage ./extensions.nix.locked {
      inherit (self.lib) buildFirefoxXpiAddon;
      inherit (channels.nixpkgs) fetchurl lib;
      stdenv = channels.nixpkgs.stdenvNoCC;
    }
  );
}
