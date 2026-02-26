{ lib, ... }:

{
  disko.devices = {
    disk = {
      nixos = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_62211251";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            GRUB = {
              type = "EF02"; # Grub MBR
              size = "1M";
            };
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "10G";
              content.type = "swap";
            };
            nix = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=1G" "mode=755" ];
    };
  };
}
