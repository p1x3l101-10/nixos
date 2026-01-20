{ pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    settings = {
      use_kitty_protocol = true;
      show_banner = false;
    };
  };
  # Autoload
  xdg.configFile."nushell/autoload" = {
    source = ./support/nu/autoload;
    recursive = true;
  };
  # Integrations
  services.ssh-agent.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
}
