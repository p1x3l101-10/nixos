{ config, pkgs, lib, ... }:
let
  enabled = config.illogical-impulse.enable;
  cursor = config.illogical-impulse.theme.cursor;
in
{
  config = lib.mkIf enabled {
    # Fonts
    fonts.fontconfig.enable = true;

    # Cursor
    home.sessionVariables = {
      XCURSOR_THEME = cursor.theme;
      XCURSOR_SIZE = 24;
    };

    home.pointerCursor = {
      package = cursor.package;
      name = cursor.theme;
      size = 24;
      gtk.enable = true;
    };

    home.file.".local/share/icons/MoreWaita" = {
      source = "${pkgs.morewaita-icon-theme}/share/icons";
    };
  };
}