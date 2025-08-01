{ config, lib, mkTarget, ... }:

mkTarget {
  name = "ashell";
  humanName = "ashell";
  configElements = [
    ({ colors }: {
      programs.ashell.settings.appearance = with colors; {
        background_color = base00;
        primary_color = base0E;
        secondary_color = base03;
        success_color = base03;
        danger_color = base08;
        text_color = base05;
        workspace_colors = [ base0D ];
        special_workspace_colors = [ base0D ];
      };
    })
    ({ fonts }: {
      programs.ashell.settings.appearance.font_name = fonts.sansSerif;
    })
  ];
}
