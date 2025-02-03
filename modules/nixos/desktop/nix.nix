{ inputs, config, lib, pkgs, ... }:
{
  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "2day";
      options = lib.mkDefault "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.latest;
  };
  environment.etc.nixos.source = "/home/pixel/Programs/nixos";
}
