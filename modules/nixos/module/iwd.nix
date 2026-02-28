{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.networking.wireless.iwd.encryptDB;
in {
  options.networking.wireless.iwd.encryptDB = {
    enable = mkOption {
      description = "Uses systemd-creds to encrypt iwd's passwords";
      type = types.bool;
      default = false;
    };
    keyLocation = mkOption {
      description = "Where to store the credential file";
      type = types.externalPath;
      default = "/var/lib/iwd/iwd-secret.cred";
    };
  };
  config = mkIf cfg.enable {
    systemd.services = {
      iwd = {
        unitConfig.ConditionPathExists = "${cfg.keyLocation}";
        serviceConfig.LoadCredentialEncrypted = "iwd-secret";
      };
      iwd-ensure-credentials = {
        description = "Generate IWD credentials";
        serviceConfig.Type = "oneshot";
        wantedBy = [ "iwd.service" ];
        before = [ "iwd.service" ];
        # Generate a random encryption password for iwd to work with
        script = ''
          set -euxo pipefail
          [[ -e "${cfg.keyLocation}" ]] && exit 0
          mkdir -p "$(dirname "${cfg.keyLocation}")"
          cd "$(dirname "${cfg.keyLocation}")"
          cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*_-' | head -c 512 | systemd-creds --name=iwd-secret encrypt - "${cfg.keyLocation}"
          chmod 0444 "${cfg.keyLocation}"
        '';
      };
    };
    environment.etc."credstore.encrypted/iwd-secret".source = cfg.keyLocation;
  };
}
