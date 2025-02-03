{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    craftos-pc
    dosbox-x
    protontricks
    bottles
    spot
    komikku
    prismlauncher
    libreoffice
    taisei
    protonup-qt
    r2modman
    syncthing
    stc-cli
    youtube-music
    steam-rom-manager
    hunspell
    hunspellDicts.en_US-large
    delfin
    wineWowPackages.waylandFull
    osu-lazer-bin
    vesktop
    bat
    glow
    gpu-screen-recorder-gtk
    file
    dar
    fragments
    calibre
    uutils-coreutils-noprefix
    tor-browser
    yt-dlp
    steamtinkerlaunch
  ];
  home.file.".local/share/Steam/steamapps/common/tModLoader/dotnet/6.0.0/dotnet".source = "${pkgs.dotnet-sdk}/bin/dotnet";
  home.file.".local/share/Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch".source = "${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch"; # Steam compat
}
