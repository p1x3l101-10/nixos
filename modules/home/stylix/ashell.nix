{ config, lib, ... }:

{
  options.stylix.targets.ashell.enable = config.lib.stylix.mkEnableTarget "ashell" true;
  config = lib.mkIf (config.stylix.targets.ashell.enable == true) (let
      inherit (config.lib.stylix) colors fonts;
    in {
    programs.ashell.settings.appearance = with colors; {
      font_name = fonts.sansSerif;
      background_color = base00;
      primary_color = base0E;
      secondary_color = base03;
      success_color = base03;
      danger_color = base08;
      text_color = base05;
      workspace_colors = [ base0D ];
      special_workspace_colors = [ base0D ];
    };
  });
}
