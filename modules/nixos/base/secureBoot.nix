{ config, lib, pkgs, ... }:
let
  keydir = "/nix/host/keys/secureboot";
  bootDir = config.boot.loader.efi.efiSysMountPoint;
  allowedEFI = config.boot.loader.efi.canTouchEfiVariables;
  fwupd = rec {
    package = pkgs.fwupd-efi;
    efi = "${package}/libexec/fwupd/efi/fwupdx64.efi";
    espDir = "${bootDir}/EFI/fwupd";
  };
  sbsign = input: output: "${pkgs.sbsigntool}/bin/sbsign --key ${keydir}/db/db.key --cert ${keydir}/db/db.cer --output ${output} ${input}";
in
{
  options.system.useSecureBoot = lib.mkOption {
    description = "Forces system to use lanzeboote for booting ukis";
    type = lib.types.bool;
    default = true;
  };
  config = lib.mkIf config.system.useSecureBoot {
    services.fwupd.enable = true;
    boot = {
      loader.systemd-boot = {
        enable = lib.mkForce false;
        extraEntries = {
          "fwupd.conf" = ''
            title Firmware Updater
            efi /EFI/fwupd/fwupd.efi
            sort-key z_fwupd
          '';
        };
      };
      loader.grub.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "${keydir}";
      };
    };
    # Make sure keys are present for system
    systemd.tmpfiles.settings."01-secureboot" = {
      "/var/lib/sbctl".L = {
        user = "root";
        group = "root";
        mode = "0700";
        argument = keydir;
      };
    };
    # Make sure keys are present for bootloader
    # Only copy pubKeys
    system.activationScripts = {
      secureBoot-keys.text = ''
        ## Copy UEFI Secure Boot public keys to ${bootDir}
        # If the keys already exist, skip this step
        if [ ! -e "${bootDir}/loader/keys/local" ]; then 
          # Announce our precence
          echo "Installing secureBoot keys..."
  
          # Ensure needed directories exist
          mkdir -p ${bootDir}/loader/keys/local
  
          # Copy variables
          cp ${keydir}/PK/PK.auth ${bootDir}/loader/keys/local
          cp ${keydir}/KEK/KEK.auth ${bootDir}/loader/keys/local
          cp ${keydir}/db/db.auth ${bootDir}/loader/keys/local
        fi
      '';
      fwupd-efi.text = lib.mkIf allowedEFI ''
        ## Sign, and copy the fwupd efi binary to ${bootDir}
        mkdir -p "${fwupd.espDir}"
        if ([ -f "${fwupd.espDir}/fwupd.hash" ] && [ $(basename "${fwupd.package}" | cut -d- -f1) != $(cat "${fwupd.espDir}/fwupd.hash")]); then
          # Package differs, copy the binary
          echo "Updating fwupd"
          rm -f "${fwupd.espDir}/fwupd.efi"
          ${sbsign fwupd.efi "${fwupd.espDir}/fwupd.efi"}
        fi
        if [ ! -f "${fwupd.espDir}/fwupd.efi" ]; then
          # Not installed
          echo "Installing fwupd to the ESP"
          ${sbsign fwupd.efi "${fwupd.espDir}/fwupd.efi"}
        fi
        basename "${fwupd.package}" | cut -d- -f1 > "${fwupd.espDir}/fwupd.hash"
      '';
    };
  };
}
