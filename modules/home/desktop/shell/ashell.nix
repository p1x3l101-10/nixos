{ config, ... }:

let
  inherit (config.lib.stylix) colors opacity;
in {
  programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = (import ./ashell.config.nix) // {
      appearance = with colors.withHashtag; {
        background_color = base00;
        primary_color = base0D;
        secondary_color = base01;
        success_color = base0B;
        danger_color = base09;
        text_color = base05;

        workspace_colors = [
          base09
          base0D
        ];
        opacity = opacity.desktop;
        menu.opacity = opacity.desktop;
      };
    };
  };
}
