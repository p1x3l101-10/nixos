{ ... }:

{
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      nixed = "pushd /etc/nixos && nvim; popd";
    };
  };
  programs.bash.enable = true;
}
