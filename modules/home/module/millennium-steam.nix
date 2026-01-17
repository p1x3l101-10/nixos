{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.programs.millennium-steam;
  bool2Str = bool: if (bool) then "yes" else "no";
  themeList = import ./support/millennium-steam/themes.nix { inherit (pkgs) fetchZip fetchFromGitHub; };
in {
  options.programs.millennium-steam = {
    enable = mkEnableOption "millenium steam user config";
    quickCss = mkOption {
      description = "CSS changes to make without theming";
      type = types.lines;
      default = "";
    };
    settings = let
      mkQO = default: type: mkOption {
        description = "Millenium JSON config value";
        inherit default type;
      };
      mkSO = default: mkQO default types.str;
      mkBO = default: mkQO default types.bool;
      mkIO = default: mkQO default types.int;
    in {
      general = {
        accentColor = mkSO "DEFAULT_ACCENT_COLOR";
        checkForMillenniumUpdates = mkBO true;
        checkForPluginAndThemeUpdates = mkBO true;
        injectCSS = mkBO true;
        injectJavascript = mkBO true;
        milleniumUpdateChannel = mkSO "stable";
        onMilleniumUpdate = mkIO 1;
        shouldShowThemePluginUpdateNotifications = mkBO true;
      };
      misc = {
        hasShownWelcomeModal = mkBO false;
      };
      themes = {
        activeTheme = mkSO "default";
        allowedScripts = mkBO true;
        allowedStyles = mkBO true;
        conditions = mkOption {
          description = "Theme conditions";
          type = with types; attrsOf (attrsOf str);
          default = {};
        };
        themeColors = mkOption {
          description = "Theme colors (in css format)";
          type = with types; attrsOf (attrsOf str);
          default = {};
        };
      };
    };
    themes = {
      NEVKO-UI = {
        enable = mkEnableOption "NEVKO-UI";
        package = mkOption {
          type = types.package;
          default = themeList.NEVKO-UI;
        };
        settings = {
          altOnlineIndicator = mkOption {
            type = types.bool;
            default = true;
          };
          avatarDecoration = mkOption {
            type = types.bool;
            default = false;
          };
          avatarRounding = mkOption {
            type = types.enum [
              "Sharp"
              "Rounded Square"
              "Circle"
            ];
            default = "Rounded Square";
          };
          blurAccountName = mkOption {
            type = types.bool;
            default = false;
          };
          blurBalance = mkOption {
            type = types.bool;
            default = false;
          };
          contributorBadges = mkOption {
            type = types.bool;
            default = true;
          };
          font = mkOption {
            type = types.enum [
              "Steam Default"
              "Inter"
              "VK Sans"
            ];
            default = "Steam Default";
          };
          gameContentLocation = mkOption {
            type = types.enum [
              "[All] Center"
              "[All] Left Side"
              "[All] Right Side"
              "[Game Links] Right Side Only"
              "[Game Links] Left Side Only"
              "[Compact] Left Side"
              "[Compact] Right Side"
            ];
            default = "[All] Center";
          };
          gamepageSide = mkOption {
            type = types.enum [
              "Left Side"
              "Right Side"
            ];
            default = "Left Side";
          };
          hideBalance = mkOption {
            type = types.bool;
            default = true;
          };
          hideProfileButton = mkOption {
            type = types.bool;
            default = true;
          };
          hideLibraryItems = mkOption {
            type = types.enum [
              "None"
              "[What's New] Only"
              "[Add Shelf] Only"
              "Both"
            ];
            default = "None";
          };
          librarySide = mkOption {
            type = types.enum [
              "Left Side"
              "Right Side"
            ];
            default = "Left Side";
          };
          moveBottomButtonsToTop = mkOption {
            type = types.bool;
            default = true;
          };
          moveURLBarToBottom = mkOption {
            type = types.bool;
            default = true;
          };
          refreshFriends = mkOption {
            type = types.bool;
            default = false;
          };
          refreshSettings = mkOption {
            type = types.bool;
            default = false;
          };
          removeWindowButtons = mkOption {
            type = types.enum [
              "None"
              "[Collapse] Only"
              "[Expand] Only"
              "[Close] Only"
              "[Collapse + Expand]"
              "[Collapse + Close]"
              "[Expand + Close]"
              "All"
            ];
            default = "None";
          };
          reorderMainButtons = mkOption {
            type = types.bool;
            default = true;
          };
          resizeLibraryList = mkOption {
            type = types.enum [
              "Default"
              "Small"
              "Medium"
              "Big"
            ];
            default = "Default";
          };
          menuStyle = mkOption {
            type = types.enum [
              "Legacy"
              "Spacious"
              "Compact"
            ];
            default = "Spacious";
          };
        };
        colorOverrides = mkOption {
          description = "Colors to override in the preset, uses the same format as settings.themes.themeColors.NEVKO-UI";
          type = with types; attrsOf str;
        };
      };
    };
  };
  config = mkIf (cfg.enable) {
    xdg.configFile = {
      "millennium/quickcss.css".text = ''
        /* Generated by Home Manager, DO NOT EDIT THIS FILE DIRECTLY! */
      '' + cfg.quickCss;
      "millennium/config.json".text = builtins.toJSON (lib.internal.attrsets.mergeAttrs [
        cfg.settings
        (if (cfg.themes.NEVKO-UI.enable) then {
          themes = {
            activeTheme = "NEVKO-UI";
            conditions.NEVKO-UI = with cfg.themes.NEVKO-UI.settings; {
              "Alternative Online Indicator" = bool2Str altOnlineIndicator;
              "Avatar Decoration" = bool2Str avatarDecoration;
              "Badges for Contributors" = bool2Str contributorBadges;
              "Blur Account Name" = bool2Str blurAccountName;
              "Blur Balance" = bool2Str blurBalance;
              "DRIVER = 1" = "";
              "DRIVER = 2" = "";
              "DRIVER = 3" = "";
              "DRIVER = 4" = "";
              "DRIVER = 5" = "";
              "Fonts [WIP]" = font;
              "Game Page Content Location" = gameContentLocation;
              "Gamepage Side" = gamepageSide;
              "Hide Balance" = bool2Str hideBalance;
              "Hide Profile Button" = bool2Str hideProfileButton;
              "Hiding Library Items" = hideLibraryItems;
              "Library Side" = librarySide;
              "Move Bottom Buttons to Top Bar" = bool2Str moveBottomButtonsToTop;
              "Move URL Bar to Bottom" = bool2Str moveURLBarToBottom;
              "Refresh Friends & Chat" = if (refreshFriends) then "Enabled" else "Disabled";
              "Refresh Settings" = if (refreshSettings) then "Enabled" else "Disabled";
              "Remove Window Buttons" = removeWindowButtons;
              "Reorder Main Buttons" = reorderMainButtons;
              "Resize Library List" = resizeLibraryList;
              "Rounding Avatars" = avatarRounding;
              "Style Menu" = menuStyle;
            };
            themeColors.NEVKO-UI = {
              "--custom-accent" = "#1A9FFF";
              "--green-color" = "#769C1F";
              "--idle-status" = "#4C91AC";
              "--ingame-status" = "#8CD61D";
              "--ingameidle-status" = "#62813B";
              "--main-background" = "#161D25";
              "--offline-status" = "#898989";
              "--online-status" = "#4CB4FF";
              "--purple-color" = "#834E8D";
            } // cfg.themes.NEVKO-UI.colorOverrides;
          };
        } else {})
      ]);
    };
    home.file = let
      skinpath = ".local/share/Steam/steamui/skins";
    in (lib.mkMerge [
      (if (cfg.themes.NEVKO-UI.enable == true) then {
        "${skinpath}/NEVKO-UI".source = cfg.themes.NEVKO-UI.package;
      } else {})
    ]);
  };
}
