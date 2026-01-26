{ config, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  mkHex = color: "#${color}";
in lib.fix (final: {
  color_text = mkHex colors.base05;
  color_accent = mkHex colors.base0B;
  color_danger = mkHex colors.base08;
  color_faded = mkHex colors.base0C;
  color_background = mkHex colors.base00;
})
