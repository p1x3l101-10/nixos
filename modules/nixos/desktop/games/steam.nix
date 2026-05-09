{ pkgs, config, ext, ... }:

let
  msPkgs = ext.inputs.millennium.packages."${ext.system}";
  # Need to patch millennium because upstream uses an input that it forgot to pass in
  millenniumFixed = msPkgs.millennium.overrideAttrs (oldAttrs: {
    buildInputs = with ext.stable.pkgs; [
      # Copied from https://github.com/SteamClientHomebrew/Millennium/blob/fa9d1ac5bd11fb22f5a5f696f15eff82a08049ee/packages/nix/millennium.nix#L23
      pkgsi686Linux.gtk3
      pkgsi686Linux.libpsl
      pkgsi686Linux.openssl
      pkgsi686Linux.libxtst
      cacert
      msPkgs.millennium-python # Updated line because it is a millennium package, not from nixpkgs
    ];
  });
  steamPkg = msPkgs.millennium-steam.override {
    millennium = millenniumFixed;
  };
in {
  programs.steam = {
    enable = true;
    package = steamPkg.override {
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
      vkd3d-proton
      thcrap-steam-proton-wrapper
    ];
    extraPackages = with pkgs; [
      gamescope
      adwaita-icon-theme
      morewaita-icon-theme
      harfbuzz # L4D2 patch https://github.com/Yi3d/l4d2-linux-patches
      # BUILD FAILURE
      #sgdboop
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
