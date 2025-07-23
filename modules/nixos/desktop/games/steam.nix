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
    extraEnv = {
      STEAM_LAUNCH_WRAPPER_SCOPE = "1";
      PRESSURE_VESSEL_SYSTEMD_SCOPE = "1";
    };
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
