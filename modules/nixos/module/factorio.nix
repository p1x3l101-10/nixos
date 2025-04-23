{ config, options, pkgs, lib, ... }:

let
  newUtils = pkgs.callPackage ./resources/factorio-utils.nix {};
  cfg = config.services.factorio;
  modSerialized = if (cfg.modList != null)
  then
    {
      mods = lib.forEach (lib.attrsToList cfg.modList) (x: { inherit (x) name; enabled = x.value; });
    }
  else null;
  modDir = newUtils.mkModDirDrv cfg.mods cfg.mods-dat cfg.modList;
in {
  options = with lib; {
    services.factorio.modList = mkOption {
      type = with types; nullOr attrSet;
      default = null;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.factorio = {
      lib.mkForce preStart =
        (toString [
          "test -e ${stateDir}/saves/${cfg.saveName}.zip"
          "||"
          "${cfg.package}/bin/factorio"
          "--config=${cfg.configFile}"
          "--create=${mkSavePath cfg.saveName}"
          (lib.optionalString (cfg.mods != [ ]) "--mod-directory=${modDir}")
        ])
        + (lib.optionalString (cfg.extraSettingsFile != null) (
          "\necho ${lib.strings.escapeShellArg serverSettingsString}"
          + " \"$(cat ${cfg.extraSettingsFile})\" | ${lib.getExe pkgs.jq} -s add"
          + " > ${stateDir}/server-settings.json"
        ));
      serviceConfig = {
        lib.mkForce ExecStart = toString [
          "${cfg.package}/bin/factorio"
          "--config=${cfg.configFile}"
          "--port=${toString cfg.port}"
          "--bind=${cfg.bind}"
          (lib.optionalString (!cfg.loadLatestSave) "--start-server=${mkSavePath cfg.saveName}")
          "--server-settings=${
            if (cfg.extraSettingsFile != null) then "${stateDir}/server-settings.json" else serverSettingsFile
          }"
          (lib.optionalString cfg.loadLatestSave "--start-server-load-latest")
          (lib.optionalString (cfg.mods != [ ]) "--mod-directory=${modDir}")
          (playerListOption "server-adminlist" cfg.admins)
          (playerListOption "server-whitelist" cfg.allowedPlayers)
          (lib.optionalString (cfg.allowedPlayers != [ ]) "--use-server-whitelist")
        ];
      };
    };
  };
}