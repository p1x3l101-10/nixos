{ pkgs, config, ... }:

let
  mcLinker = (pkgs.callPackage ./support/linker.nix {}) {
    pathsToLink = [
      "styles"
      "everbook"
      "tlm_custom_pack"
      "figura"
    ];
    defaults = [
      "options.txt"
      "resourcepacks"
      "shaderpacks"
      "servers.dat"
    ];
  };
  inherit (config.stylix) fonts;
in {
  programs.prismlauncher = {
    enable = true;
    settings = {
      ConfigVersion = "1.3"; # Effectivly a config state marker
      ApplicationTheme = "system";
      AutoCloseConsole = true;
      AutomaticJavaDownload = false;
      AutomaticJavaSwitch = true;
      CloseAfterLaunch = false;
      ConsoleFont = fonts.monospace.name;
      DownloadsDir = config.xdg.userDirs.download;
      DownloadsDirWatchRecursive = true;
      EnableFeralGamemode = false;
      EnableMangoHud = false;
      Env = builtins.toJSON {};
      FlameKeyOverride = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
      FlameKeyShouldBeFetchedOnStartup = false;
      IconTheme = "flat_white";
      IgnoreJavaCompatibility = false;
      IgnoreJavaWizard = true;
      InstRenamingMode = "PhysicalDir";
      InstSortMode = "Name";
      LaunchMaximized = true;
      NumberOfConcurrentDownloads = 6;
      NumberOfConcurrentTasks = 10;
      NumberOfManualRetries = 2;
      OnlineFixes = true;
      PreLaunchCommand = "${mcLinker}/bin/mc-linker";
      QuitAfterGameStop = false;
      RecordGameTime = true;
      ShowConsole = true;
      ShowConsoleOnError = true;
      ShowGameTime = true;
      ShowGameTimeWithoutDays = true;
      ShowGlobalGameTime = true;
      SkipModpackUpdatePrompt = false;
      WrapperCommand = "gamemoderun";
    };
  };
}
