{ config, pkgs, nixosConfig, ... }:

{
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.withPackages (ext: with ext; [
      steam-library
      (pkgs.callPackage ./resources/kodi-extensions/the-tvdb-v4.nix { })
    ]);

    sources = {
      video = {
        default = "Movies";
        source = [
          { name = "Movies"; path = "${config.xdg.userDirs.videos}/Movies"; allowsharing = "true"; }
          { name = "TV"; path = "${config.xdg.userDirs.videos}/TV"; allowsharing = "true"; }
        ];
      };
      music = {
        default = "Music";
        source = [{ name = "Music"; path = config.xdg.userDirs.music; allowsharing = "true"; }];
      };
      pictures = {
        default = "Camera";
        source = [
          { name = "Camera"; path = "${config.home.homeDirectory}/Camera"; allowsharing = "true"; }
          { name = "Pictures"; path = config.xdg.userDirs.pictures; allowsharing = "true"; }
        ];
      };
    };

    addonSettings = {
      "service.xbmc.versioncheck".versioncheck_enable = "false";
      "skin.estuary" = {
        homemenunomusicvideobutton = "true";
        homemenunoradiobutton = "true";
        homemenunofavbutton = "true";
        homemenunovideosbutton = "true";
        homemenunotvbutton = "true";
        homemenunoprogramsbutton = "true";
      };
    };

    settings = {
      services.devicename = nixosConfig.networking.hostName;
      general.addonupdates = "2";
      screensaver.mode = "screensaver.xbmc.builtin.dim";
      videolibrary = {
        tvshowsselectfirstunwatcheditem = "2";
        tvshowsincludeallseasonsandspecials = "2";
        flattentvshows = "0";
      };
    };
  };
}
