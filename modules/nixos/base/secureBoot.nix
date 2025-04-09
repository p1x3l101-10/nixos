{ config, lib, ... }:
let
  keydir = "/nix/host/keys/secureboot";
  bootDir = config.boot.loader.efi.efiSysMountPoint;
in
{
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "${keydir}";
    };
  };
  # Make sure keys are present for system
  systemd..tmpfiles.settings."01-secureboot" = {
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
  };
}
