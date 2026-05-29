{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.framework.enableKmod = true;
  # Start iwd AFTER the wifi device comes online
  # Adapted from https://wiki.archlinux.org/title/Iwd#Restarting_iwd.service_after_boot
  systemd.services.iwd = {
    wants = [ "sys-devices-pci0000:00-0000:00:02.2-0000:01:00.0-net-wlan0.device" ];
    after = [ "sys-devices-pci0000:00-0000:00:02.2-0000:01:00.0-net-wlan0.device" ];
    serviceConfig.ExecStartPre = "ip link set wlan0 up";
  };
}
