{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ./kvm.nix ./disko-config.nix ];
  networking.hostName = "pixels-server";
  networking.hostId = "fb383b5f";
  environment.etc.machine-id.text = "fb383b5f66074c8e91d65a3e545bef83";
}
