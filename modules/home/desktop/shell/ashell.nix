{ ... }:

{
  programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = import ./ashell.config.nix;
  };
}
