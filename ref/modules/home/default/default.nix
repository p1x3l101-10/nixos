{ nixosConfig, inputs, ... }:
{
  imports = [
    ./arrpc.nix
    ./gnome/toplevel.nix
    ./obs.nix
    ./clematis.nix
    ./user-pictures.nix
    ./syncthing-ignore.nix
    ./git.nix
    ./packages.nix
    ./prismlauncher-shortcuts.nix
    ./shell.nix
    ./editor.nix
    ./firefox.nix
    #./autostart.nix
    ./kodi.nix
    ./hide-desktop.nix
  ];
  home = {
    username = nixosConfig.users.users.pixel.name;
    homeDirectory = nixosConfig.users.users.pixel.home;
    stateVersion = nixosConfig.system.stateVersion;
  };
  programs.home-manager.enable = true;
}
