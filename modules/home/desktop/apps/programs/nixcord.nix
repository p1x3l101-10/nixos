{ config, ext, pkgs, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  genRGB = baseId: (
    "rgb(${colors."base${baseId}-rgb-r"}, ${colors."base${baseId}-rgb-g"}, ${colors."base${baseId}-rgb-b"})"
  );
  inherit (config.stylix) opacity fonts;
  opacityHex = lib.toHexString (builtins.ceil (opacity.applications * 255));
in
{
  # Override how stylix will generate the theme file so I can inject an alpha channel into the css generation (among other things)
  stylix.targets.nixcord.themeBody = lib.mkForce (
    let
      loadNix = file: import "${ext.inputs.stylix.outPath}/modules/discord/common/${file}.nix";
    in
    (
      (loadNix "theme-header")
      + ((loadNix "font-theme") fonts)
      + ((loadNix "color-theme") (builtins.listToAttrs 
        (
          let
            # How many bases (starting from 00) should have an alpha channel
            injectToBase = 8;
          in
          # Inject the alpha channel into theme generation
          (map
            (base: {
              name = base;
              value = "${colors."${base}"}${opacityHex}"; 
            })
            (builtins.genList (x: "base0${lib.toHexString x}") injectToBase)
          )
          # Leave the remaining bases untouched
          ++ (map
            (base: {
              name = base;
              value = colors."${base}";
            })
            (builtins.genList (x: "base0${lib.toHexString (x + injectToBase)}") (16 - injectToBase))
          )
        )
      ))
    )
  );
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
    ];
  };
  services.arrpc = {
    enable = true;
    systemdTarget = "graphical-session.target";
  };
}
