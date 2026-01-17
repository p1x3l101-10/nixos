{ config, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  mkHexColor = color: "#${color}";
in {
  programs.millennium-steam = {
    enable = true;
    settings = {
      general = {
        shouldShowThemePluginUpdateNotifications = false;
        checkForMillenniumUpdates = false;
        checkForPluginAndThemeUpdates = false;
      };
      misc.hasShownWelcomeModal = true;
    };
    themes = {
      SpaceTheme = {
        enable = true;
        settings = {
          general.titlebar.windowControls = "Hide";
          store = {
            gamepage.hideBroadcast = true;
            cart.hideDigitalProduct = true;
          };
          library = {
            home.hideAddShelf = true;
            gamepage.biggerBanner = true;
          };
        };
        colorOverrides = let
          mkColor = colorID: "${colors."base${colorID}-rgb-r"}, ${colors."base${colorID}-rgb-g"}, ${colors."base${colorID}-rgb-b"}";
        in {
          "--st-accent-1" = mkColor "0E";
          "--st-accent-2" = mkColor "09";
          "--st-color-1" = mkColor "01";
          "--st-color-2" = mkColor "01";
          "--st-color-3" = mkColor "02";
          "--st-color-4" = mkColor "02";
          "--st-color-5" = mkColor "01";
          "--st-color-6" = mkColor "01";
          "--st-background" = mkColor "00";
          "--st-red" = mkColor "08";
          "--st-red-hover" = mkColor "08";
          "--st-green" = mkColor "0B";
          "--st-green-hover" = mkColor "0B";
          "--st-blue" = mkColor "0D";
          "--st-blue-hover" = mkColor "0D";
          "--st-yellow" = mkColor "0A";
          "--st-yellow-hover" = mkColor "0A";
        };
      };
      NEVKO-UI = {
        #enable = true;
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
  };
  xdg.configFile."millennium/config.json".force = true;
}
