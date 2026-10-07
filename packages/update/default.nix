{ ext
, callPackage
, nix
, nix-output-monitor
}:

let
  nuLibs = callPackage ./libs.nix {};
in

nuLibs.mkNuScript {
  name = "update-flake";

  packageDir = ./.;

  binaryPath = [
    nix
    nix-output-monitor
  ];
}
