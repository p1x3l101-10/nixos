{ lib
, gitMinimal
, writeShellScriptBin
}:

writeShellScriptBin "rebuild" ''
  cd /etc/nixos
  ${gitMinimal}/bin/git pull
  sudo nix shell nixpkgs#nix --command nixos-rebuild $''+''{1:-"boot"}
''