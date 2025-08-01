{ osConfig, lib, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ../module
    ../stylix
  ] ++ (lib.internal.confTemplates.importList ./.);
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
