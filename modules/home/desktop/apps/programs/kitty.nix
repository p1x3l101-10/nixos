{ ... }:

{
  programs.kitty = {
    enable = true;
  };
  stylix.targets.kitty.opacity.enable = false; # Done through hyprland
  home.sessionVariables = {
    TERMINAL = "kitty";
    TERM = "kitty";
  };
}
