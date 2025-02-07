{ lib
, gitMinimal
, writeShellScriptBin
}:

writeShellScriptBin ''
  cd /etc/nixos
  ${gitMinimal}/bin/git pull
  sudo nix shell nixpkgs#nix --command nixos-rebuild switch
''