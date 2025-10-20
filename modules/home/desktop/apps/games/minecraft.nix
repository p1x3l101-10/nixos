{ inputs, pkgs, ... }:

{
  home.packages = [
    #inputs.fjordlauncher.packages."${pkgs.system}".fjordlauncher
    (pkgs.prismlauncher.override ({
      jdks = with pkgs; [
        jdk8
        jdk17
        jdk21
        jdk25
      ];
    }))
  ];
}
