{ config, ext, pkgs, ... }:

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
        MINIMIZE_TO_TRAY = true;
        discordBranch = "stable";
        minimizeToTray = true;
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
      plugins = {
        accountPanelServerProfile.enable = true;
        betterGifAltText.enable = true;
        betterGifPicker = {
          enable = true;
          keepOpen = true;
        };
        betterSessions.enable = true;
        betterSettings.enable = true;
        blurNsfw.enable = true;
        callTimer.enable = true;
        clearUrls.enable = true;
        copyFileContents.enable = true;
        customRpc.enable = true;
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
        fixYoutubeEmbeds.enable = true;
        friendsSince.enable = true;
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
  };
  services.arrpc = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };
}
