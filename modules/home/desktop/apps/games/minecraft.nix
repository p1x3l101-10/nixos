{ inputs, ... }:

{
  home.packages = [
    inputs.fjordlauncher.packages."${pkgs.system}".fjordlauncher
  ];
}
