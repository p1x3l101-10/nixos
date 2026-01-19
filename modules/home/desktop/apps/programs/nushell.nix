{ ... }:

{
  programs.nushell = {
    enable = true;
  };
  # Integrations
  services.ssh-agent.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.nix-your-shell.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
}
