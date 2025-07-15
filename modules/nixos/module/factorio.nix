{ config, options, pkgs, lib, ... }:

let
  newUtils = pkgs.callPackage ./resources/factorio-utils.nix { };
  cfg = config.services.factorio;
  modSerialized =
    if (cfg.modList != null)
    then
      {
        mods = lib.forEach (lib.attrsToList cfg.modList) (x: { inherit (x) name; enabled = x.value; });
      }
    else null;
  modDir = newUtils.mkModDirDrv cfg.mods cfg.mods-dat cfg.modList;
  # Copied from the module
  stateDir = "/var/lib/${cfg.stateDirName}";
  mkSavePath = name: "${stateDir}/saves/${name}.zip";
  serverSettings = {
    name = cfg.game-name;
    description = cfg.description;
    visibility = {
      public = cfg.public;
      lan = cfg.lan;
    };
    username = cfg.username;
    password = cfg.password;
    token = cfg.token;
    game_password = cfg.game-password;
    require_user_verification = cfg.requireUserVerification;
    max_upload_in_kilobytes_per_second = 0;
    minimum_latency_in_ticks = 0;
    ignore_player_limit_for_returning_players = false;
    allow_commands = "admins-only";
    autosave_interval = cfg.autosave-interval;
    autosave_slots = 5;
    afk_autokick_interval = 0;
    auto_pause = true;
    only_admins_can_pause_the_game = true;
    autosave_only_on_server = true;
    non_blocking_saving = cfg.nonBlockingSaving;
  } // cfg.extraSettings;
  serverSettingsString = builtins.toJSON (lib.filterAttrsRecursive (n: v: v != null) serverSettings);
  serverSettingsFile = pkgs.writeText "server-settings.json" serverSettingsString;
  playerListOption =
    name: list:
    lib.optionalString
      (
        list != [ ]
      ) "--${name}=${pkgs.writeText "${name}.json" (builtins.toJSON list)}";
in
{
  options = with lib; {
    services.factorio.modList = mkOption {
      type = with types; nullOr attrSet;
      default = null;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.factorio = {
      preStart = lib.mkForce (
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
        ))
      );
      serviceConfig = {
        ExecStart = lib.mkForce (toString [
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
        ]);
      };
    };
  };
}
