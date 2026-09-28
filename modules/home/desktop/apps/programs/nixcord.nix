{ config, ext, pkgs, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  genRGB = baseId: (
    "rgb(${colors."base${baseId}-rgb-r"}, ${colors."base${baseId}-rgb-g"}, ${colors."base${baseId}-rgb-b"})"
  );
in
{
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
      # Make the background translucant
      # NOTE: This partially overrides stylix, so I need to reimpliment some of its themeing as well
      (
        let
          inherit (config.lib.stylix) colors;
          inherit (config.stylix) opacity;
          opacityHex = lib.toHexString (builtins.ceil (opacity.applications * 255));
          mkColorWithOpacity = base: alpha: "${colors.withHashtag."base${base}"}${alpha}";
          mkColor = base: mkColorWithOpacity base opacityHex;
          noColor = "#000000${opacityHex}"; # For when I can't find a match in stylix's theme
        in
        ''
          :root,
          .theme-light,
          .theme-dark,
          .theme-darker,
          .theme-midnight,
          .visual-refresh {
            --background-secondary: ${mkColor "01"} !important;
            --background-primary: ${mkColor "00"} !important;
            --background-tertiary: ${mkColor "00"} !important;
            --home-background: ${mkColor "00"} !important;
            --bg-base-primary: ${noColor} !important;
            --background-base-lowest: ${mkColor "00"} !important;
            --background-base-lower: ${mkColor "00"} !important;
            --background-modifier-accent: ${mkColor "02"} !important;
          }
        ''
      )
      # Collapse sidebar
      ''
        [aria-label="Servers sidebar"] + div:has(nav > #channels),
        body:has(#channels) [aria-label="User area"] {
          width: 0px !important;
          transition: width 0.3s ease-in-out !important;

          .buttons__37e49 {
            display: none !important;
          }

          &:hover {
            width: 250px !important;
            .buttons__37e49 {
              display: flex !important;
            }
          }
        }

        body:has([aria-label="Servers sidebar"]:hover) [aria-label="Servers sidebar"] + div:has(nav > #channels) {
          width: 250px !important;
        }
      ''
    ];
  };
  services.arrpc = {
    enable = true;
    systemdTarget = "graphical-session.target";
  };
}
