{ osConfig, lib, ext, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ../module
    ../stylix
  ] ++ (with ext.inputs; [
    nix-flatpak.homeManagerModules.nix-flatpak
  ]) ++ (lib.internal.confTemplates.importList ./.);
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
