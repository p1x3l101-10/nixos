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
    "secureboot/GUID" = { source = "${keydir}/GUID"; mode = "0644"; };
    "secureboot/keys/PK/PK.key" = { source = "${keydir}/PK/PK.key"; mode = "0400"; };
    "secureboot/keys/PK/PK.pem" = { source = "${keydir}/PK/PK.pem"; mode = "0444"; };
    "secureboot/keys/KEK/KEK.key" = { source = "${keydir}/KEK/KEK.key"; mode = "0400"; };
    "secureboot/keys/KEK/KEK.pem" = { source = "${keydir}/KEK/KEK.pem"; mode = "0444"; };
    "secureboot/keys/db/db.key" = { source = "${keydir}/db/db.key"; mode = "0400"; };
    "secureboot/keys/db/db.pem" = { source = "${keydir}/db/db.pem"; mode = "0444"; };
  };
  # Make sure keys are present for bootloader
  # Only copy pubKeys
  system.activationScripts = {
    secureBoot-keys.text = ''
      ## Copy UEFI Secure Boot public keys to ${bootDir}

      # Announce our precence
      echo "Installing secureBoot keys..."

      # Ensure needed directories exist
      mkdir -p ${bootDir}/KEYS
      mkdir -p ${bootDir}/KEYS/AUTH
      mkdir -p ${bootDir}/KEYS/ESL
      mkdir -p ${bootDir}/KEYS/CER

      # Some firmware needs AUTH files
      cp ${keydir}/PK/PK.auth ${bootDir}/KEYS/AUTH
      cp ${keydir}/KEK/KEK.auth ${bootDir}/KEYS/AUTH
      cp ${keydir}/db/db.auth ${bootDir}/KEYS/AUTH

      # Some firmware needs ESL Files
      cp ${keydir}/PK/PK.esl ${bootDir}/KEYS/ESL
      cp ${keydir}/KEK/KEK.esl ${bootDir}/KEYS/ESL
      cp ${keydir}/db/db.esl ${bootDir}/KEYS/ESL

      # Some firmware needs CER Files
      cp ${keydir}/PK/PK.cer ${bootDir}/KEYS/CER
      cp ${keydir}/KEK/KEK.cer ${bootDir}/KEYS/CER
      cp ${keydir}/db/db.cer ${bootDir}/KEYS/CER
    '';
  };
}
