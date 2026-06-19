{ config, lib, ... }:

let
  inherit (config.lib.stylix) colors mkOpacityHexColor;
  inherit (config.stylix) fonts opacity;
  mkConf = attrs: lib.hm.generators.toHyprconf {
    inherit attrs;
    importantPrefixes = [ "$" ];
  };
  mkColor = base: mkOpacityHexColor colors."base${base}-hex" opacity.popups;
  iconTheme = with config.stylix; icons.${polarity};
in {
  xdg.configFile."hypr/hyprtoolkit.conf".text = mkConf {
    background = mkColor "00";
    base = mkColor "01";
    text = mkColor "04";
    alternate_base = mkColor "02";
    bright_text = mkColor "07";
    accent = mkColor "0C";
    accent_secondary = mkColor "0D";
    h1_size = 19;
    h2_size = 15;
    h3_size = 13;
    font_size = 11;
    small_font_size = 10;
    icon_theme = iconTheme;
    font_family = fonts.sansSerif.name;
    font_family_monospace = fonts.monospace.name;
    rounding_large = 10;
    rounding_small = 5;
  };
}
