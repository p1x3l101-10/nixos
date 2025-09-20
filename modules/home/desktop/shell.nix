{ config, ... }:

{
  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      ned = "pushd /etc/nixos && nvim; popd";
      nrt = "sudo nixos-rebuild test";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
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
