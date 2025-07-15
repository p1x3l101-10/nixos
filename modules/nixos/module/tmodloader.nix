{ config, options, pkgs, lib, ... }:
let
  cfg = config.services.tmodloader;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib) types;
  mkJourneyOption = mkOption {
    type = types.enum [
      "locked"
      "hostOnly"
      "all"
    ];
    default = cfg.journey.defaultPerm;
    example = "all";
    description = "Journey mode control";
  };
  fromJourney = (o:
    toString (lib.attrByPath [ o ] 0 {
      locked = 0;
      hostOnly = 1;
      all = 2;
    })
  );
in
{
  options.services.tmodloader = {
    enable = mkEnableOption "tModLoader server";
    difficulty = mkOption {
      type = with types; enum [
        "journey"
        "classic"
        "expert"
        "master"
      ];
      default = "classic";
      example = "journey";
    };
    port = mkOption {
      type = types.port;
      default = 7777;
    };
    password = mkOption {
      type = types.str;
      default = "N/A";
      example = "strongPassword";
    };
    world = {
      name = mkOption {
        type = types.str;
        default = "The Sacred Valley";
      };
      seed = mkOption {
        type = with types; oneOf [ str int ];
        default = "nix";
        example = "forTheWorthy";
        description = "World seed, accepts a number or string";
      };
      size = mkOption {
        type = types.enum [
          "small"
          "medium"
          "large"
        ];
        default = "large";
        description = "World Size";
      };
    };
    mods = {
      enabled = mkOption {
        type = with types; listOf int;
        default = [ ];
        description = "List of Steam Workshop ids to enable";
      };
      download = mkOption {
        type = with types; listOf int;
        default = cfg.mods.enabled;
        description = ''
          List of Steam Workstop ids to download
          NOTE: This is only needed to cache a download
        '';
      };
      config = mkOption {
        type = with types; attrsOf attrs;
        default = { };
        example = {
          NoFishingQuests_Config = {
            useCustomCurrency = true;
            goldMultiplier = "2.0";
          };
        };
        description = ''
          The mod configuration
          These are turned into JSON files under `<data>/ModConfigs/<name>.json`
        '';
      };
    };
    journey = {
      defaultPerm = mkOption {
        type = types.enum [
          "locked"
          "hostOnly"
          "all"
        ];
        default = "locked";
        example = "all";
        description = "Default setting for all journey settings";
      };
      setFrozen = mkJourneyOption;
      setDawn = mkJourneyOption;
      setNoon = mkJourneyOption;
      setDusk = mkJourneyOption;
      setMidnight = mkJourneyOption;
      godmode = mkJourneyOption;
      windStrength = mkJourneyOption;
      rainStrength = mkJourneyOption;
      timeSpeed = mkJourneyOption;
      rainFrozen = mkJourneyOption;
      windFrozen = mkJourneyOption;
      placementRange = mkJourneyOption;
      setDifficulty = mkJourneyOption;
      biomeSpread = mkJourneyOption;
      spawnRate = mkJourneyOption;
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically open the specified ports in the firewall.";
    };
    image = mkOption {
      type = types.package;
      default = pkgs.internal.dockerTmodloader;
      example = pkgs.internal.dockerTmodloader.override { imageDigest = "sha256:digest-here"; sha256 = "valid-hash"; };
      description = "tModLoader server image";
    };
    extraConfig = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = ''
        Extra values to add to config
        This is put first, and is overridden by other config values
      '';
    };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.tmodloader = {
      serviceName = "tmodloader";
      environment = (lib.internal.attrsets.mergeAttrs (
        let inherit (lib.internal.environment) mkEnv mkEnvList mkEnvRaw; in [
          cfg.extraConfig
          (mkEnvRaw "tmod_pass" cfg.password)
          (mkEnvRaw "tmod_worldname" cfg.world.name)
          (mkEnvRaw "tmod_worldseed" cfg.world.seed)
          (mkEnv "tmod_difficulty" (lib.attrsets.attrByPath [ cfg.difficulty ] 0 {
            journey = -1;
            classic = 0;
            expert = 1;
            master = 2;
          }))
          (mkEnv "tmod_worldsize" (lib.attrsets.attrByPath [ cfg.difficulty ] 0 {
            small = 0;
            medium = 1;
            large = 2;
          }))
          (mkEnvList "tmod_autodownload" cfg.mods.download ",")
          (mkEnvList "tmod_enabledMods" cfg.mods.enabled ",")
          (mkEnv "tmod_journey_setFrozen" (fromJourney cfg.journey.setFrozen))
          (mkEnv "tmod_journey_setDawn" (fromJourney cfg.journey.setDawn))
          (mkEnv "tmod_journey_setNoon" (fromJourney cfg.journey.setNoon))
          (mkEnv "tmod_journey_setDusk" (fromJourney cfg.journey.setDusk))
          (mkEnv "tmod_journey_godmode" (fromJourney cfg.journey.godmode))
          (mkEnv "tmod_journey_wind_strength" (fromJourney cfg.journey.windStrength))
          (mkEnv "tmod_journey_rain_strength" (fromJourney cfg.journey.rainStrength))
          (mkEnv "tmod_journey_time_speed" (fromJourney cfg.journey.timeSpeed))
          (mkEnv "tmod_journey_rain_frozen" (fromJourney cfg.journey.rainFrozen))
          (mkEnv "tmod_journey_wind_rozen" (fromJourney cfg.journey.windFrozen))
          (mkEnv "tmod_journey_placement_range" (fromJourney cfg.journey.placementRange))
          (mkEnv "tmod_journey_set_difficulty" (fromJourney cfg.journey.setDifficulty))
          (mkEnv "tmod_journey_biome_spread" (fromJourney cfg.journey.biomeSpread))
          (mkEnv "tmod_journey_spawn_rate" (fromJourney cfg.journey.spawnRate))
        ]
      ));
      image = "internal/docker-tmodloader:latest";
      imageFile = cfg.image;
      ports = [
        "${toString cfg.port}:7777"
      ];
      volumes = [
        "/var/cache/tModLoader/workshop:/data/steamMods"
        "/var/cache/tModLoader/dotnet:/terraria-server/dotnet"
        "/var/lib/tModLoader:/data/tModLoader/Worlds"
        "/etc/tModLoader/ModConfigs:/data/tModLoader/ModConfigs"
      ];
      autoStart = true;
    };
    systemd.tmpfiles.settings."50-tmodloader" = {
      "/var/lib/tModLoader".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/cache/tModLoader/workshop".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/cache/tModLoader/dotnet".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/etc/tModLoader/ModConfigs".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
    virtualisation.containers.enable = true;
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    environment.etc = lib.mapAttrs' (name: value: lib.nameValuePair ("tModLoader/ModConfigs/" + name + ".json") { text = (builtins.toJSON value); mode = "0444"; }) cfg.mods.config;
  };
}
