{ pkgs, ... }:

let
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
    package = pkgs.vesktop.overrideAttrs (oldAttrs: {
      desktopItems = [
        ((builtins.elemAt oldAttrs.desktopItems 0).override {
          exec = "vesktop --ozone-platform-hint=auto %U";
        })
      ];
    });
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
        plugins = enabledPlugins [];
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
}
