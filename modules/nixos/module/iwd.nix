{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.networking.wireless.iwd.encryptDB;
in {
  options.networking.wireless.iwd.encryptDB = {
    enable = mkOption {
      description = "Uses systemd-creds with the tpm chip to encrypt iwd's passwords";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    systemd.services = {
      # Dont start IWD until there is a valid credential
      iwd = {
        unitConfig.ConditionPathExists = "/var/lib/systemd/credential.secret";
        serviceConfig.LoadCredentialEncrypted = "iwd-secret:/var/lib/systemd/credential.secret";
      };
    };
  };
}
