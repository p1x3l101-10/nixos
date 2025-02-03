{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ./kvm.nix ./disko-config.nix ];
  networking.hostName = "pixels-laptop";
  networking.hostId = "5e0107e3";
}
