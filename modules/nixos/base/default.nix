{ inputs, ... }:
{
  imports = with inputs; [
    lanzaboote.nixosModules.lanzaboote
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko

    ./autoUpgrade.nix
    ./base.nix
    ./bash.nix
    ./cachix.nix
    ./cache.nix
    ./content-addressed.nix
    ./git.nix
    ./impermanence.nix
    ./ipfs.nix
    ./locale.nix
    ./secureBoot.nix
    ./ssh.nix
  ];
}
