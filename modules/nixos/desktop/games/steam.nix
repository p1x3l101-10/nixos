{ pkgs, config, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        STEAM_LAUNCH_WRAPPER_SCOPE = "1";
        PRESSURE_VESSEL_SYSTEMD_SCOPE = "1";
        DRI_PRIME = "0";
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";
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
      sgdboop
    ] ++ [
      config.home-manager.users.pixel.home.pointerCursor.package
    ];
  };
  environment.systemPackages = with pkgs; [
    # BUILD FAILURE
    #sgdboop
  ];
  system.allowedUnfree.packages = [
    "steam"
    "steam-unwrapped"
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      package32 = pkgs.pkgsi686Linux.mesa;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-tools
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-tools
      ];
    };
    steam-hardware.enable = true;
  };
}
