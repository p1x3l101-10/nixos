{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.programs.millennium-steam.themes.SpaceTheme;
  bool2Str = bool: if (bool) then "yes" else "no";
  bool2StrED = bool: if (bool) then "Enabled" else "Disabled";
  themeList = import ../themeList.nix { inherit (pkgs) fetchZip fetchFromGitHub; };
  inherit (import ../paths.nix) skinpath;
  mkDefaultStr = option: default: if (option == default) then "${option} (default)" else option;
  mkSimpleBool = description: mkOption {
    inherit description;
    type = types.bool;
    default = false;
  };
in {
  options.programs.millennium-steam.themes.SpaceTheme = {
    enable = mkEnableOption "SpaceTheme";
    package = mkOption {
      type = types.package;
      default = themeList.SpaceTheme;
    };
    settings = {
      # NOTE: any spelling errors here reflect the mistakes of upstream
      # I am trying to match the option location to the upstream locations as much as possible
      general = {
        titlebar = {
          windowControls = mkOption {
            description = "Hide the Window Controls (Minimize, Maximize, Close) from the titlebar";
            type = types.enum [
              "Show"
              "Show only on hover"
              "Hide"
            ];
            default = "Show";
          };
        };
        sidebar = {
          navigationButtons = mkSimpleBool "Hide Navigation buttons";
          alwaysShowSidebar = mkOption {
            description = "Always show the sidebar \n (If you have this option on Disabled, and you use the \"Userpannel\" or \"Sidebar only on hover\" option, this option will be overwritten)";
            type = types.bool;
            default = true;
          };
          sidebarOnHover = mkSimpleBool "Shows only the sidebar in the store on hover";
          friendIcon = mkSimpleBool "Hide the friend icon from the game item";
        };
        userpannel = {
          hideWalletBalance = mkSimpleBool "Hide wallet balance";
          hideVRButton = mkSimpleBool "Hide Steam VR button from userpannel";
          hideBigPicture = mkSimpleBool "Hide Big Picture Mode button from userpannel";
          hideNews = mkSimpleBool "Hide News button from userpannel";
          hideNotificationButton = mkSimpleBool "Hide Notification button from userpannel";
          hideFriendsList = mkSimpleBool "Hide Friend list button from userpannel (only with Userpannel experimental)";
        };
        other = {
          font = mkOption {
            description = "Use a different font for the SteamUI";
            type = types.enum [
              "Be Vietnam Pro"
              "Arial"
              "gluten"
              "Montserrat"
              "Quicksand"
              "Roboto"
              "Source Code Pro"
              "Ubuntu"
            ];
            default = "Be Vietnam Pro";
          };
          /*
          # Only works on windows, only here for sake of completeness (and so I dont feel like I forgot something
          systemAccentColors
          */
          acrylicSupport = mkSimpleBool "Support for Mica and Acrylic plugin https://steambrew.app/plugin?id=b4c58634419b (Only works with the standard theme colors)";
          achievementNotification = mkSimpleBool "Hide the Achievment Notification (Sound is still there)";
        };
        experimental = {
          userpannel = mkSimpleBool "Moves the user buttons and the download bar to the game sidebar";
          gameOverlay = mkSimpleBool "Game Overlay from the concept";
        };
      };
      store = {
        gamepage = {
          hideBroadcast = mkSimpleBool "Hide broadcasts on the store gamepage";
          infoSidebarOnRight = mkSimpleBool "Changes the info sidebar from right to left";
          hideReviewWrite = mkSimpleBool "Hide the Write a Review section";
        };
        cart = {
          hideRecommendations = mkSimpleBool "Hide recommendations in the cart";
          hideDigitalProduct = mkSimpleBool "Hides the info that the purchase is a digital product";
          hideFollowCreators = mkSimpleBool "Hide Follow the creators";
        };
        pointsShop = {
          hideLandingHeader = mkSimpleBool "Hide the landing header (this with the big coin)";
        };
        other = {
          hideURLBar = mkSimpleBool "Hide URL bar";
          hideFooter = mkSimpleBool "Hide Valve/Steam footer";
        };
      };
      library = {
        pined = {
          customArtSupport = mkSimpleBool "The best support for https://spacetheme.net/#steam-custom-artworks ";
        };
        home = {
          whatsNew = mkOption {
            description = "Customize the What's New section";
            type = types.enum [
              "Show"
              "Compact"
              "Hide"
            ];
            default = "Compact";
          };
          hideAddShelf = mkSimpleBool "Hide Add shelf button in Library";
          hideShinyCover = mkSimpleBool "Hide shiny effect on game covers";
          darkenUninstalled = mkOption {
            description = "Darkens game cards when they are not installed";
            type = types.bool;
            default = true;
          };
        };
        gamepage = {
          bannerPos = mkOption {
            description = "Change the position of the banner (applies to all banners)";
            type = types.enum [
              "Left"
              "Middle"
              "Right"
            ];
            default = "Middle";
          };
          biggerBanner = mkSimpleBool "Bigger banner on the game page";
          bannerInfoOnHover = mkSimpleBool "Only show banner infos (collection, hltb plugin infos) on hover";
          alwaysShowGameInfo = mkSimpleBool "Always show game infos on the game page";
          hideInfoArt = mkSimpleBool "Hide Artwork in game info box";
          sidebarOnLeft = mkSimpleBool "Changes the sidebar on the game page from right to left";
        };
      };
      community = {
        profile = {
          hideVACBans = mkOption {
            description = "Hide the VAC ban from your profile or on all profiles";
            type = types.enum [
              "Show"
              "For me"
              "For all"
            ];
            default = "Show";
          };
        };
        other = {
          hideProfilePageHeader = mkSimpleBool "Hide the profile pages header";
        };
      };
    };
    colorOverrides = mkOption {
      description = "Colors to override in the preset";
      type = with types; attrsOf str;
      default = {};
    };
  };
  config = mkIf (cfg.enable) {
    programs.millennium-steam.settings.themes = {
      activeTheme = "SpaceTheme";
      conditions.SpaceTheme = with cfg.settings; {
        "General - Window Controls" = general.titlebar.windowControls;
        "General - Navigation buttons" = bool2Str general.sidebar.navigationButtons;
        "General - Always show sidebar" = bool2StrED general.sidebar.alwaysShowSidebar;
        "General - Sidebar only on hover" = bool2Str general.sidebar.sidebarOnHover;
        "General - Friend icon" = bool2Str general.sidebar.friendIcon;
        "General - Wallet balance" = bool2Str general.userpannel.hideWalletBalance;
        "General - Steam VR button" = bool2Str general.userpannel.hideVRButton;
        "General - Big Picture Mode button" = bool2Str general.userpannel.hideBigPicture;
        "General - News button" = bool2Str general.userpannel.hideNews;
        "General - Notification button" = bool2Str general.userpannel.hideNotificationButton;
        "General - Friend list button" = bool2Str general.userpannel.hideFriendsList;
        "General - Font" = mkDefaultStr general.other.font "Be Vietnam Pro";
        "General - System accent colors" = bool2Str false;
        "General - Mica & Acrylic plugin support" = bool2Str general.other.acrylicSupport;
        "General - Achievement Notification" = bool2Str general.other.achievementNotification;
        "General - Userpannel" = bool2Str general.experimental.userpannel;
        "General - Game Overlay" = bool2Str general.experimental.gameOverlay;
        "Store - Broadcast" = bool2Str store.gamepage.hideBroadcast;
        "Store - Info sidebar on right" = bool2Str store.gamepage.infoSidebarOnRight;
        "Store - Write a Review" = bool2Str store.gamepage.hideReviewWrite;
        "Store - Recommendations" = bool2Str store.cart.hideRecommendations;
        "Store - Digital product info" = bool2Str store.cart.hideDigitalProduct;
        "Store - Follow the creators" = bool2Str store.cart.hideFollowCreators;
        "Store - Landing Header" = bool2Str store.pointsShop.hideLandingHeader;
        "Store - URL bar" = bool2Str store.other.hideURLBar;
        "Store - Footer" = bool2Str store.other.hideFooter;
        "Library - Steam-Custom-Artworks Support" = bool2Str library.pined.customArtSupport;
        "Library - What's New" = library.home.whatsNew;
        "Library - Add shelf button" = bool2Str library.home.hideAddShelf;
        "Library - Game cover shiny effect" = bool2Str library.home.hideShinyCover;
        "Library - Darken not installed games" = bool2Str library.home.darkenUninstalled;
        "Library - Banner position" = mkDefaultStr library.gamepage.bannerPos "Middle";
        "Library - Bigger banner" = bool2Str library.gamepage.biggerBanner;
        "Library - Banner Infos" = bool2Str library.gamepage.bannerInfoOnHover;
        "Library - Always show game infos" = bool2Str library.gamepage.alwaysShowGameInfo;
        "Library - Game info box artwork" = bool2Str library.gamepage.hideInfoArt;
        "Library - Sidebar on left" = bool2Str library.gamepage.sidebarOnLeft;
        "Community - VAC-Ban visibility" = community.profile.hideVACBans;
        "Community - Profile pages header" = bool2Str community.other.hideProfilePageHeader;
      };
      themeColors.SpaceTheme = {
        "--st-accent-1" = "102, 108, 255";
        "--st-accent-2" = "135, 140, 255";
        "--st-color-1" = "17, 17, 17";
        "--st-color-2" = "30, 30, 30";
        "--st-color-3" = "20, 20, 20";
        "--st-color-4" = "24, 24, 24";
        "--st-color-5" = "38, 41, 44";
        "--st-color-6" = "38, 38, 41";
        "--st-background" = "10, 10, 10";
        "--st-red" = "240, 74, 74";
        "--st-red-hover" = "242, 99, 99";
        "--st-green" = "36, 166, 90";
        "--st-green-hover" = "39, 185, 100";
        "--st-blue" = "75, 137, 239";
        "--st-blue-hover" = "100, 154, 242";
        "--st-yellow" = "239, 141, 75";
        "--st-yellow-hover" = "239, 141, 75";
      } // cfg.colorOverrides;
    };
    home.file."${skinpath}/SpaceTheme".source = cfg.package;
  };
}
