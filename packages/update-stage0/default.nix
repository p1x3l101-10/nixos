{ lib
, writeShellScriptBin
}:

writeShellScriptBin "update-stage0" ''
  nix build nixpkgs#make-minimal-bootstrap-sources --out-link /nix/var/nix/gcroots/stage0-src
''
