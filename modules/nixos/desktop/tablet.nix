{ config, ... }:

{
  users.groups.tablet = { };
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="${config.users.groups.tablet.name}"
  '';
}
