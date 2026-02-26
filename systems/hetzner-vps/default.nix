{ config, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ./kvm.nix ./disko-config.nix ];
  networking.hostName = "hetzner-vps";
  networking.hostId = "6b4d18e8";
  environment.etc.machine-id.text = "6b4d18e892d8456fafb8e4dc441fad92";

  system.useSecureBoot = false;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    copyKernels = false;
    storePath = "/store";
    device = "/dev/sda";
  };
}
