{ lib, ... }:

{
  imports = [
    ./base-min.nix
    ./config.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];
  networking.hostName = "nixbook";
  environment.etc.machine-id.text = "492415bb34cd428889d8764f37e7a1b2";
  networking.hostId = "492415bb";
}