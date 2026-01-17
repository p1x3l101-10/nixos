{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ./kvm.nix ./disko-config.nix ./lighting.nix ];
  networking.hostName = "pixels-pc";
  environment.etc.machine-id.text = "c2b9de128d004668baadd6bd861149ad";
  networking.hostId = "c2b9de12";

  # Begin host fixes:
  #systemd.oomd.enable = false;
  #systemd.services."systemd-timesyncd".serviceConfig.ProtectKernelModules = "no";
}
