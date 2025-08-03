{ osConfig, lib, ext, ... }:

{
  imports = [
    ./apps
    ./hyprland
    ../module
    ../stylix
  ] ++ (with ext.inputs; [
    nix-flatpak.homeManagerModules.nix-flatpak
    zen-browser.homeModules.twilight
    nixvim.homeModules.nixvim
  ]) ++ (lib.internal.confTemplates.importList ./.);
  home = {
    allowedUnfree.enable = true;
    stateVersion = osConfig.system.stateVersion;
  };
}
