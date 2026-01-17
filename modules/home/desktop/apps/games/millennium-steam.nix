{ config, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  mkHexColor = color: "#${color}";
in {
  programs.millennium-steam = {
    enable = true;
    settings = {
      misc.hasShownWelcomeModal = true;
    };
    themes.NEVKO-UI = {
      enable = true;
      settings = {
        removeWindowButtons = "All";
      };
      colorOverrides = with colors; {
        "--custom-accent" = mkHexColor base0B;
        "--green-color" = mkHexColor green;
        "--idle-status" = mkHexColor base0D;
        "--ingame-status" = mkHexColor base0A;
        "--ingameidle-status" = mkHexColor base0C;
        "--main-background" = mkHexColor base00;
        "--offline-status" = mkHexColor base03;
        "--online-status" = mkHexColor cyan;
        "--purple-color" = mkHexColor base0E;
      };
    };
  };
  xdg.configFile."millennium/config.json".force = true;
}
