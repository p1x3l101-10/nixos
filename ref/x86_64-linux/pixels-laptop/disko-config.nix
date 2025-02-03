{
  disko.devices = {
    disk = {
      nixos = {
        device = "/dev/disk/by-id/ata-PNY_CS900_500GB_SSD_PNY2413240329010043D";
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
              };
            };
            swap = {
              size = "30G";
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
      mountOptions = [ "defaults" "size=500m" "mode=755" ];
    };

    nodev."/home" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=5G" "mode=755" ];
    };

    nodev."/tmp" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=20G" "mode=755" ];
    };
  };
}
