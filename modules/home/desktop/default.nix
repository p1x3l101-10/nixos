{ osConfig, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ./modules.nix
    ./user-images.nix
  ];
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
