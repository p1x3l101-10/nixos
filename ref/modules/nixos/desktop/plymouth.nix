{ pkgs, ... }:
{
  boot.loader.systemd-boot.configurationLimit = 10;
  nixos-boot = {
    enable = true;
    bgColor = {
      red = 0;
      green = 0;
      blue = 0;
    };
  };
}
