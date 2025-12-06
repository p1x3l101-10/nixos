{ inputs, pkgs, ... }:

{
  home.packages = [
    #inputs.fjordlauncher.packages."${pkgs.stdenv.hostPlatform.system}".fjordlauncher
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
