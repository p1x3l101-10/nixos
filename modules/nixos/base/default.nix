{ lib, inputs, ... }:
{
  imports = [
    #./autoUpgrade.nix
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
  nix.registry = lib.internal.confTemplates.registry inputs;
}
