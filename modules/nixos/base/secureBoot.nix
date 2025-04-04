{ config, lib, ... }:
let
  keydir = "/nix/host/keys/secureboot/keys";
  bootDir = config.boot.loader.efi.efiSysMountPoint;
in
{
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "${keydir}/..";
    };
  };
  # Make sure keys are present for system
  environment.etc = {
    "secureboot/GUID".source = "${keydir}/GUID";
    "secureboot/keys/PK/PK.key".source = "${keydir}/PK/PK.key";
    "secureboot/keys/PK/PK.pem".source = "${keydir}/PK/PK.pem";
    "secureboot/keys/KEK/KEK.key".source = "${keydir}/KEK/KEK.key";
    "secureboot/keys/KEK/KEK.pem".source = "${keydir}/KEK/KEK.pem";
    "secureboot/keys/db/db.key".source = "${keydir}/db/db.key";
    "secureboot/keys/db/db.pem".source = "${keydir}/db/db.pem";
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
  };
}
