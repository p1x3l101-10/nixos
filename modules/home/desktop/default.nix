{ osConfig, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ./user-images.nix
  ] ++ [
    ../module
    ../stylix
  ];
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
