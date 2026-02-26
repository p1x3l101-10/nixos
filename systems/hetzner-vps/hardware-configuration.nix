{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  systemd.network.networks."10-wan" = {
    networkConfig.DHCP = "no";
    address = [
      "5.78.134.177/32"
      "2a01:4ff:1f0:c947::/64"
    ];
    routes = [
      { routeConfig.Gateway = "fe80::1"; }
      { routeConfig = { Destination = "172.31.1.1"; }; }
      { routeConfig = { Gateway = "172.31.1.1"; GatewayOnLink = true; }; }
    ];
  };
}
