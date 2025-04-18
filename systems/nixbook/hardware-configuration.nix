{ config, lib, pkgs, ... }:

{
  # Slim the image
  system = {
    tools = {
      nixos-version.enable = false;
      nixos-rebuild.enable = false;
      nixos-option.enable = false;
      nixos-install.enable = false;
      nixos-generate-config.enable = false;
      nixos-enter.enable = false;
      nixos-build-vms.enable = false;
    };
    includeBuildDependencies = false;
    etc.overlay = {
      enable = true;
      mutable = false;
    };
  };
  services.userborn.enable = true;
  nix.enable = false;
  /*
  nixpkgs.hostPlatform = {
    gcc = {
      arch = "x86-64";
      tune = "generic";
    };
    system = "x86_64-linux";
  };
  */
}
