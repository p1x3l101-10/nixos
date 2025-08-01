{ ... }:

{
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      ned = "pushd /etc/nixos && nvim; popd";
    };
  };
  programs.bash.enable = true;
}
