{ osConfig, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ./user-images.nix
  ];
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
