{ ... }:

{
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      ned = "pushd /etc/nixos && nvim; popd";
      nrt = "sudo nixos-rebuild test";
    };
  };
  programs.bash.enable = true;
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };
}
