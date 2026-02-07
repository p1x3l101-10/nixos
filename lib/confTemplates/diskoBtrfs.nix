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
    format = "btrfs";
    subvolumes = {
      "/nix" = {
        mountpoint = "/nix";
      };
      "/nix/store" = {
        mountOptions = [
          "compress=zstd"
          "noatime"
          "nodatacow"
          "discard=async"
          "flushoncommit"
        ];
        mountpoint = "/nix/store";
      };
      "/nix/host/keys" = {
        mountOptions = [
          "compress=zstd"
          "noatime"
          "autodefrag"
        ];
        mountpoint = "/nix/host/keys";
      };
      "/nix/host/state" = {
        mountpoint = "/nix/host/state";
      };
      "/nix/host/state/UserData" = {
        mountOptions = [
          "compress=zstd"
        ];
        mountpoint = "/nix/host/state/UserData";
      };
      "/swap" = {
        mountpoint = "/.swapvol";
        swap.swapfile.size = swap-size;
      };
    };
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

  boot.initrd.luks = luksIf {
    fido2Support = true;
    systemd.fido2.enable = true;
    devices.nix = {
      fallbackToPassword = true;
      crypttabExtraOpts = ["fido2-device=auto"];
      # NOTE: You will need to manually enroll these keys
      fido2 = {
        passwordLess = true;
        gracePeriod = 10;
        credentials = [
          "c916081a02987f4f065c2a823582867fd127f0962998bedfe98cd29a30b7c1425ea2d7b1f59c6398e5bdd74a6668896a"
        ];
      };
    };
  };
}
