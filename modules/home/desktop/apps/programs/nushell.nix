{ pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      hcl
      skim
      dbus
      units
      query
      gstat
      semver
      polars
      formats
      highlight
      desktop_notifications
    ];
    settings = {
      use_kitty_protocol = true;
    };
  };
  # Integrations
  services.ssh-agent.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
}
