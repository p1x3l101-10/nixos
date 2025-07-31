{ inputs, ... }:

{
  imports = with inputs; [
    illogical-impulse.homeManagerModules.default
  ];
}