{ lib, osConfig, ... }:
{
  imports = lib.optionals osConfig.services.xserver.desktopManager.gnome.enable [
    ./app-folders.nix
    ./bookmarks.nix
    ./extensions.nix
    ./preferances.nix
    ./shortcuts.nix
    ./evince.nix
    ./packages.nix
    ./mime.nix
    ./bookmarks.nix
    ./web.nix
  ];
}
