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
        colorOverrides = with colors; {
          "--st-accent-1" = mkHexColor base0E;
          "--st-accent-2" = mkHexColor base09;
          "--st-color-1" = mkHexColor base01;
          "--st-color-2" = mkHexColor base03;
          "--st-color-3" = mkHexColor base02;
          "--st-color-4" = mkHexColor base02;
          "--st-color-5" = mkHexColor base03;
          "--st-color-6" = mkHexColor base03;
          "--st-background" = mkHexColor base00;
          "--st-red" = mkHexColor red;
          "--st-red-hover" = mkHexColor bright-red;
          "--st-green" = mkHexColor green;
          "--st-green-hover" = mkHexColor bright-green;
          "--st-blue" = mkHexColor blue;
          "--st-blue-hover" = mkHexColor bright-blue;
          "--st-yellow" = mkHexColor yellow;
          "--st-yellow-hover" = mkHexColor bright-yellow;
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
