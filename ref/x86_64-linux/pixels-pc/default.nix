{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ./kvm.nix ./disko-config.nix ];
  networking.hostName = "pixels-pc";

  # Begin host fixes:
  systemd.oomd.enable = false;
  systemd.services."systemd-timesyncd".serviceConfig.ProtectKernelModules = "no";
}
