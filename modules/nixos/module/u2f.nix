{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types mkMerge;
  strOpt = mkOption { type = types.str; };
  keySubmodule = {
    options = {
      keyHandle = strOpt;
      userKey = strOpt;
      coseType = strOpt;
      options = strOpt;
    };
  };
  userSubmodule = {
    options = {
      keys = mkOption {
        type = with types; listOf (submodule keySubmodule);
        default = [];
      };
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  cfg = config.services.u2f;
in {
  options.services.u2f = {
    enable = mkEnableOption "u2f";
    keyManagement = mkOption {
      description = "Toggles use of users attrset";
      type = types.bool;
      default = true;
    };
    users = mkOption {
      type = with types; attrsOf (submodule userSubmodule);
      default = {};
    };
    pam = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      inherit (options.security.pam.u2f) control settings;
    };
    lockOnUnplug = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      security.pam.u2f = mkIf cfg.pam.enable {
        inherit (cfg.pam) enable control settings;
      };
      services.udev.extraRules = mkIf cfg.lockOnUnplug ''
        ACTION=="remove",\
          ENV{SUBSYSTEM}=="usb",\
          ENV{PRODUCT}=="1050/407/574",\
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    }
    (mkIf cfg.keyManagement {
      security.pam.u2f.settings.authfile = lib.mkForce "/etc/u2f-mappings";
      environment.etc.u2f-mappings.text = builtins.concatStringsSep "\n" (map
        ({ name, value }: if (value.enable) then (builtins.concatStringsSep ":" (
          [ name ] ++
          (map
            ({ keyHandle, userKey, coseType, options }:
              builtins.concatStringsSep ","
              [
                keyHandle
                userKey
                coseType
                options
              ]
            )
            value.keys
          )
        )) else (""))
        (lib.attrsToList cfg.users)
      );
    })
  ]);
}
