{ lib, ext, self }:

{ disk-id
  # Actual disk
, esp-size ? "500M"
, swap-size ? "20G"
  # tmpfs systems
, root-size ? "4G"
, useLuks ? false
, luksYubikeys ? []
}:

let
  # Warning wrapper until I am ready to use this
  luksWarning = (
    if (useLuks) then (
      builtins.warn "lib.confTemplates.disko: luks support is not yet finished, use at your own peril" true
    ) else (
      false
    )
  );
  luksOpt = normal: luks: (
    if (useLuks) then (
      luks
    ) else (
      normal
    )
  );
  inherit (lib) mkIf;
  luksIf = pred: (mkIf (useLuks) pred);
  defaultFS = {
    type = "filesystem";
    format = "ext4";
    mountpoint = "/nix";
  };
in

{
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
              content = luksOpt defaultFS {
                type = "luks";
                name = "nix";
                settings.allowDiscards = true;
                passwordFile = "/tmp/secret.key";
                content = defaultFS;
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
  };

  boot.initrd = luksIf {
    systemd.fido2.enable = true;
    luks = {
      fido2Support = true;
      devices.nix = {
        fallbackToPassword = true;
        crypttabExtraOpts = ["fido2-device=auto"];
        fido2 = {
          passwordLess = true;
          gracePeriod = 10;
          credentials = [
            "c916081a02987f4f065c2a823582867fd127f0962998bedfe98cd29a30b7c1425ea2d7b1f59c6398e5bdd74a6668896a"
          ];
        };
      };
    };
  };
}
