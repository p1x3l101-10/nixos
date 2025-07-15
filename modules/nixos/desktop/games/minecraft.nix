{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.fjordlauncher.packages."${pkgs.system}".fjordlauncher
  ];
}