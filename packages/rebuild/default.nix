{ lib
, writeShellApplication
, gitMinimal
, nix
, nixos-rebuild
}:

writeShellApplication {
  name = "init";
  runtimeInputs = [
    gitMinimal
    nix
    nixos-rebuild
  ];
  text = ''
    cd /etc/nixos
    git pull
    sudo nixos-rebuild $'' + ''{1:-"boot"}
  '';
}
