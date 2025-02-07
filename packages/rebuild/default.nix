{ lib
, gitMinimal
, writeShellScriptBin
}:

writeShellScriptBin ''
  cd /etc/nixos
  ${git}/bin/git pull
  sudo nix shell nixpkgs#nix --command nixos-rebuild switch
''