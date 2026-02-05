{ config, pkgs, lib, ... }:

let
  cfg = config.pam.u2f;
  inherit (lib) mkIf mkOption types;
  strOpt = mkOption { type = types.str; };
in {
  options.pam.u2f.authorizedYubiKeys = mkOption {
    description = "List of authorized YubiKey token IDs";
    type = with types; listOf (submodule {
      options = {
        keyHandle = strOpt;
        userKey = strOpt;
        coseType = strOpt;
        options = strOpt;
      };
    });
    default = [];
  };
  config = (mkIf (cfg.authorizedYubiKeys != []) {
    xdg.configFile."Yubico/u2f_keys".text = builtins.concatStringsSep ":" (
      [ config.home.username ] ++
      (map
        (x:
          builtins.concatStringsSep ","
          [
            x.keyHandle
            x.userKey
            x.coseType
            x.options
          ]
        )
        cfg.authorizedYubiKeys
      )
    );
  });
}
