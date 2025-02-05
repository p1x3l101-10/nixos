{ inputs, ... }:

{
  imports = with inputs; [
    self.nixosModules.base
    lanzaboote.nixosModules.lanzaboote
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko
  ];
}