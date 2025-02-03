{ lib
, inputs
, ...
}:

{
  confTemplates.disko =
    { disk-id
      # Actual disk
    , esp-size ? "500m"
    , swap-size ? "20G"
      # tmpfs systems
    , root-size ? "4G"
    , tmp-size ? "10G"
    }: {
      disko.devices = {
        disk = {
          nixos = {
            device = "/dev/disk/by-id/${disk-id}";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                BOOT = {
                  type = "EF00";
                  size = esp-size;
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/efi";
                    mountOptions = [ "defaults" "umask=0077" ];
                  };
                };
                swap = {
                  size = swap-size;
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
          mountOptions = [ "defaults" "size=${root-size}" "mode=755" ];
        };

        nodev."/tmp" = {
          fsType = "tmpfs";
          mountOptions = [ "defaults" "size=${tmp-size}" "mode=755" ];
        };
      };
    };
}
