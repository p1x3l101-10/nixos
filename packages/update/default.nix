{ ext
, nix
, nix-output-monitor
, nushell
, git
}:

ext.lib.builders.nushell.mkNuScript {
  name = "update-flake";

  packageDir = ./.;

  binaryPath = [
    nix
    nix-output-monitor
    nushell
    git
  ];
}
