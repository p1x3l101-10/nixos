{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.fjordlauncher."${pkgs.system}".fjordlauncher
  ];
}