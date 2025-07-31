{ osConfig, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ./modules.nix
  ];
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
