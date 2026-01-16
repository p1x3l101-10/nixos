{ config, ... }:

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
      plugins = {
        accountPanelServerProfile.enable = true;
        betterGifAltText.enable = true;
        betterSessions.enable = true;
        betterSettings.enable = true;
        BlurNSFW.enable = true;
        callTimer.enable = true;
        ClearURLs.enable = true;
        copyFileContents.enable = true;
        CustomRPC.enable = true;
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
        fixYoutubeEmbeds.enable = true;
        friendsSince.enable = true;
        loadingQuotes.enable = true;
        mentionAvatars.enable = true;
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
