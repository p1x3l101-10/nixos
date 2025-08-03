{ pkgs, ... }:

{
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      ned = "pushd /etc/nixos && nvim; popd";
      nrt = "sudo nixos-rebuild test";
    };
    packages = with pkgs; [
      kdePackages.qtdeclarative
      llvmPackages_21.clang-tools
      nil
      bash-language-server
    ];
  };
  programs.bash.enable = true;
}
