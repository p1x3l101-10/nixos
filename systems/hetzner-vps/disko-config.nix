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
            BOOT = {
              type = "EF02";
              size = "1M";
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
