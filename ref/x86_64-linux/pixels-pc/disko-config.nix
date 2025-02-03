{
  disko.devices = {
    disk = {
      nixos = {
        device = "/dev/disk/by-id/nvme-SPCC_M.2_PCIe_SSD_2022062900281_1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" ];
              };
            };
            swap = {
              size = "50G";
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

    nodev."/home" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=8G" "mode=755" ];
    };

    nodev."/tmp" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=20G" "mode=755" ];
    };
  };
}
