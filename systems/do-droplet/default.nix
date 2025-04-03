{ lib, modulesPath, ... }:

{
  imports = [ ./hardware-configuration.nix ./base-min.nix ./config.nix ];
  networking.hostName = "do-droplet";
  environment.etc.machine-id.text = "98b8855dd64e40a39c4ab8cb54520895";
  networking.hostId = "98b8855d";
}