{ pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    settings = {
      use_kitty_protocol = true;
      show_banner = false;
      completions.external = {
        enable = true;
        max_results = 100;
        completer = "{|spans| carapace $spans.0 nushell ...$spans | from json }";
      };
    };
  };
  # Autoload
  xdg.configFile."nushell/autoload" = {
    source = ./support/nu/autoload;
    recursive = true;
  };
  # External completions
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  # Integrations
  services.ssh-agent.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
}
