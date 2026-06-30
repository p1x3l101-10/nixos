{ pkgs, lib, config, ... }:

let
  inherit (config.lib.nushell) mkNushellInline;
in {
  programs.nushell = {
    enable = true;
    settings = {
      use_kitty_protocol = true;
      show_banner = false;
      completions.external = {
        enable = true;
        max_results = 100;
        completer = mkNushellInline "{|spans| carapace $spans.0 nushell ...$spans | from json }";
      };
    };
    extraConfig = builtins.readFile ./support/nu/config.nu;
    loginFile.source = ./support/nu/login.nu;
  };
  # Autoload
  xdg.configFile."nushell/autoload" = {
    source = ./support/nu/autoload;
    recursive = true;
  };
  xdg.configFile."nushell/modules" = {
    source = ./support/nu/modules;
    recursive = true;
  };
  xdg.configFile."nushell/scripts" = {
    source = ./support/nu/scripts;
    recursive = true;
  };
  # External completions
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  # Integrations
  services.gpg-agent.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
  home.packages = [
    pkgs.jc
  ];
}
