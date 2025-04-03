{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/virtualisation/digital-ocean-image.nix") ];
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
    forbiddenDependenciesRegexes = [
      "-dev$"
    ];
    image = {
      id = "do-droplet";
      version = "1";
    };
    includeBuildDependencies = false;
    etc.overlay = {
      enable = true;
      mutable = false;
    };
  };
  services.userborn.enable = true;
  nix.enable = false;
}
