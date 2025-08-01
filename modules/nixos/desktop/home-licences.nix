{ config, lib, ... }:
{
  # Any unfree packages home manager uses
  system.allowedUnfree = lib.mkIf (config.home-manager.users.pixel.home.allowedUnfree.enable) {
    inherit (config.home-manager.users.pixel.home.allowedUnfree) packages;
  };
}
