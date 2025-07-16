{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      steam-play-none
    ];
    extraPackages = with pkgs; [
      gamescope
      adwaita-icon-theme
      morewaita-icon-theme
    ];
  };
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
  system.allowedUnfree.packages = [
    "steam"
    "steam-unwrapped"
  ];
}
