{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ./kvm.nix ./disko-config.nix ];
  networking.hostName = "pixels-laptop";
  networking.hostId = "dd1c170a";
  environment.etc.machine-id.text = "dd1c170ad32148e09e7014adf076f233";
}
