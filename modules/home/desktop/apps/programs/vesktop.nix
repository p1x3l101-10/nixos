{ ext, ... }:

let
  pkgs = ext.stable.pkgs;
  enabledPlugins = list: (
    builtins.listToAttrs (builtins.map (x:
      {
        name = x;
        value = { enabled = true; };
      }
    ) list)
  );
in {
  programs.vesktop = {
    enable = true;
    package = pkgs.vesktop;
    vencord = {
      useSystem = true;
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = false;
        themeLinks = [];
        enabledThemes = [];
        enableReactDevtools = false;
        frameless = true;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = enabledPlugins [
          "AccountPanelServerProfile"
          "BetterGifAltText"
          "BetterSessions"
          "BetterSettings"
          "BlurNSFW"
          "CallTimer"
          "ClearURLs"
          "CopyFileContents"
          "CustomRPC"
          "FavoriteEmojiFirst"
          "FavoriteGifSearch"
          "FixYoutubeEmbeds"
          "FriendsSince"
          "LoadingQuotes"
          "MentionAvatars"
          "YoutubeAdblock"
          "VolumeBooster"
        ];
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };
        # No cloud needed
        #cloud = {};
      };
    };
  };
  xdg.configFile = {
    "vesktop/settings.json".text = builtins.toJSON {
      discordBranch = "stable";
      minimizeToTray = true;
      arRPC = true;
      splashColor = "rgb(223, 224, 226)";
      splashBackground = "rgb(29, 32, 33)";
      tray = true;
      openLinksWithElectron = false;
      hardwareVideoAcceleration = true;
      spellCheckLanguages = [
        "en-US"
        "en"
      ];
    };
    "vesktop/state.json" = {
      force = true;
      text = builtins.toJSON {
        firstLaunch = false;
      };
    };
  };
}
