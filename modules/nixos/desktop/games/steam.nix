{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        STEAM_LAUNCH_WRAPPER_SCOPE = "1";
        PRESSURE_VESSEL_SYSTEMD_SCOPE = "1";
        DRI_PRIME = "0";
      };
    };
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
  environment.systemPackages = with pkgs; [
    r2modman
  ];
  system.allowedUnfree.packages = [
    "steam"
    "steam-unwrapped"
  ];
  hardware.graphics = {
    enable32Bit = true;
    package32 = pkgs.pkgsi686Linux.mesa;
  };
}
