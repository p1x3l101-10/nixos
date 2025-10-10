{ inputs, pkgs, ... }:

{
  home.packages = [
    #inputs.fjordlauncher.packages."${pkgs.system}".fjordlauncher
    pkgs.prismlauncher
  ];
}
