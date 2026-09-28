{ config, ext, pkgs, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  genRGB = baseId: (
    "rgb(${colors."base${baseId}-rgb-r"}, ${colors."base${baseId}-rgb-g"}, ${colors."base${baseId}-rgb-b"})"
  );
  inherit (config.stylix) opacity fonts;
  opacityHex = lib.toHexString (builtins.ceil (opacity.applications * 255));
  mkColor = base: "#${colors."base${base}"}${opacityHex}";
in
{
  # Override how stylix will generate the theme file so I can inject an alpha channel into the css generation (among other things)
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop = {
      enable = true;
      settings = {
        MINIMIZE_TO_TRAY = false;
        discordBranch = "stable";
        minimizeToTray = false;
        arRPC = true;
        splashColor = genRGB "0D";
        splashBackground = genRGB "00";
        tray = true;
        openLinksWithElectron = false;
        hardwareVideoAcceleration = true;
        spellCheckLanguages = [
          "en-US"
          "en"
        ];
      };
      state = {
        firstLaunch = false;
      };
    };
    config = {
      autoUpdateNotification = false;
      frameless = true;
      useQuickCss = true;
      transparent = true;
      plugins = {
        accountPanelServerProfile.enable = true;
        betterGifAltText.enable = true;
        betterGifPicker.enable = true;
        betterSessions.enable = true;
        betterSettings.enable = true;
        blurNsfw.enable = true;
        callTimer.enable = true;
        clearUrls.enable = true;
        copyFileContents.enable = true;
        customRpc.enable = true;
        favoriteEmojiFirst.enable = true;
        fixYoutubeEmbeds.enable = true;
        loadingQuotes.enable = true;
        mentionAvatars.enable = true;
        messageLogger = {
          enable = true;
          collapseDeleted = true;
          deleteStyle = "overlay";
          ignoreBots = true;
          ignoreSelf = false;
          ignoreSelfEdits = false;
          inlineEdits = false;
          logDeletes = true;
          logEdits = true;
        };
        noF1.enable = true;
        noProfileThemes.enable = true;
        openInApp = {
          enable = true;
          steam = true;
          vrcx = true;
        };
        shikiCodeblocks = {
          enable = true;
          customTheme = (let
            stylixBasePath = ext.inputs.stylix.outPath;
            vsCodeTemplatePath = "${stylixBasePath}/modules/vscode/templates/theme.nix";
            vsCodeTheme = import vsCodeTemplatePath config.lib.stylix.colors;
            vsCodeThemeFile = pkgs.writers.writeJSON "shiki-theme-stylix.json" vsCodeTheme;
          in "file://${vsCodeThemeFile}");
          tryHljs = "SECONDARY";
          useDevIcon = "COLOR";
        };
        spotifyCrack.enable = true;
        youtubeAdblock.enable = true;
        volumeBooster.enable = true;
        webRichPresence.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
    quickCss = builtins.concatStringsSep "\n" [
      # Hide the annoying profile effects
      ''
        video[class*="img_"],
        [class*="avatarDecoration_"],
        [class^="profileEffects_"] {
          display: none !important;
        }
      ''
      # Transparancy
      ''
        :root,
        .theme-light,
        .theme-dark {
          --background-secondary: #00000000 !important;
          --background-primary: #00000000 !important;
          --background-tertiary: #00000000 !important;
          --home-background: #00000000 !important;
          --bg-base-primary: #00000000 !important;
          --background-base-lowest: transparent !important;
          --background-base-lower: transparent !important;
          --background-modifier-accent: transparent !important;
        }

        html,
        body,
        nav,
        header,
        .app-root,
        #pass-sidebar,
        #main,
        #content,
        section,
        .callContainer_cb9592,
        .bg__960e4,
        .tabBody__133bf,
        .sidebarList_c48ade,
        main,
        .chat_f75fb0,
        .page_c48ade,
        .children__9293f::after,
        .header__34c2c,
        .contentRegionScroller__23e6b,
        .container_f369db,
        [aria-label="Resize Sidebar"],
        .visual-refresh .root_bfe55a,
        main + div,
        main + div > aside > div,
        #online-tab + div > aside {
          background-color: transparent !important;
          background: none !important;
          box-shadow: none !important;
          transition:
            background-color 0.5s ease-in-out,
            background 0.5s ease-in-out,
            border 0.5s ease-in-out,
            box-shadow 0.5s ease-in-out !important;
        }

        .mainCard_f369db {
          background: none !important;
        }

        .floating__01ae2 {
          background-color: var(--panel-bg) !important;
        }
      ''
    ];
  };
  services.arrpc = {
    enable = true;
    systemdTarget = "graphical-session.target";
  };
}
