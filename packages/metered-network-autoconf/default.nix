{ ext
, callPackage
}:

let
  nuLibs = callPackage ./libs.nix {};
in

nuLibs.mkNuScript {
  name = "metered-network-autoconf";
  packageDir = ./.;
}
