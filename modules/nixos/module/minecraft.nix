# NOTE: THIS IS UNFINISHED
# TODO: expand the list of options exposed without relying on cfg.settings.extraEnv
{ config, options, pkgs, lib, ... }:
let
  cfg = config.services.minecraft;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib) types;
  mkMcOption = description: mkOption {
    type = with types; nullOr str;
    default = null;
    inherit description;
  };
  mkMcIntOption = description: mkOption {
    type = with types; nullOr int;
    default = null;
    inherit description;
  };
  curseforgeMod = _: with lib; {
    options = {
      modId = mkOption {
        type = with types; nullOr int;
        default = null;
        description = "modId or slug must be set";
      };
      slug = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "modId or slug must be set";
      };
      versionId = mkOption {
        type = with types; nullOr int;
        default = null;
      };
      partialFilename = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };
  modrinthMod = _: with lib; {
    options = {
      modId = mkOption {
        type = types.str;
      };
      versionId = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      dataPack = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  portPair = _: with lib; {
    options = {
      to = mkOption {
        type = types.port;
      };
      from = mkOption {
        type = with types; nullOr port;
        default = null;
      };
      protocol = mkOption {
        type = with types.enum [
          "udp"
          "tcp"
        ];
        default = "tcp";
      };
    };
  };
in
{
  options.services.minecraft = with lib; {
    enable = mkEnableOption "Minecraft Server";
    generic = {
      pack = mkMcOption "Generic Pack URL";
      forceUpdate = mkEnableOption "force update";
    };
    curseforge = {
      apiKey = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      pack = {
        slug = mkMcOption "";
        fileId = mkMcIntOption "";
      };
      mods = mkOption {
        type = with types; listOf (coercedTo str (slug: { inherit slug; }) (submodule curseforgeMod));
        default = [ ];
        description = "List of mods from modrinth to install";
        example = ''
          [
            "TODO: MAKE EXAMPLE"
          ]
        '';
      };
    };
    modrinth = {
      pack = {
        project = mkMcOption "";
        loader = mkOption {
          type = with types; nullOr (enum [
            "forge"
            "fabric"
            "quilt"
            "neoforge"
          ]);
          default = null;
        };
        version = mkMcOption "";
      };
      mods = {
        projects = mkOption {
          type = with types; listOf (coercedTo str (modId: { inherit modId; }) (submodule modrinthMod));
          default = [ ];
          description = "List of mods from modrinth to install";
          example = ''
            [
              "coroutil"
              { modId = "toms-storage"; versionId = "UjCLHkAa"; }
              { datapack = true; modId = "terralith"; versionId = "2.5.5"; }
            ]
          '';
        };
        downloadDependancies = mkOption {
          type = types.enum [
            "none"
            "required"
            "optional"
          ];
          default = "none";
        };
        allowedVersionType = mkOption {
          type = types.enum [
            "release"
            "beta"
            "alpha"
          ];
          default = "release";
        };
      };
    };
    packwiz = {
      url = mkMcOption "PackWiz pack.toml url";
    };
    settings = {
      eula = mkEnableOption "Agree to EULA";
      openFirewall = mkEnableOption "Open firewall ports";
      memory = mkOption {
        type = types.int;
        default = 8;
        description = "The amount of memory (in gigabytes) to allocate";
      };
      java = {
        version = mkOption {
          type = types.enum [
            "8"
            "17-alpine"
            "17-graalvm"
            "21-alpine"
            "21-graalvm"
            "25"
          ];
          default = "21-alpine";
          description = "Java version to select";
        };
        args = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = "JVM arguments";
        };
        DDargs = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = "JVM DD arguments (shorthand list)";
        };
        XXargs = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = "JVM XX arguments (shorthand list)";
        };
      };
      type = mkOption {
        type = types.enum [
          "vanilla"
          # Vanilla+
          "paper"
          # Modloaders
          "fabric"
          "forge"
          "quilt"
          "neoforge"
          # Modpacks
          "auto_curseforge"
          "ftba"
          "modrinth"
          # Other (unsupported, hack away at extraEnv)
          "crucible"
          "limbo"
          "spongevanilla"
          "custom"
        ];
        default = "vanilla";
        description = "Server type to use";
      };
      version = mkMcOption "";
      allowFlight = mkEnableOption "flying";
      port = mkOption {
        type = types.port;
        default = 25565;
      };
      extraEnv = mkOption {
        type = with types; attrsOf str;
        default = { };
        description = "Extra environment variables to merge into server";
      };
      extraPorts = mkOption {
        type = with types; listOf (coercedTo port (to: { inherit to; }) (submodule portPair));
        default = [ ];
        description = "Extra ports to map";
      };
      rconStartup = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "RCon commands to run on server startup";
      };
      stopTimeout = mkMcIntOption "Duration of time for the server to wait before forcefully stopping";
      customServer = mkMcOption "Custom server jar";
      forgeVersion = mkMcOption "";
      fabricVersion = mkMcOption "";
      whitelist = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "List of players to whitelist";
      };
      ops = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "List of players to op";
      };
      spawnProtection = mkMcIntOption "Spawn protection radius (0 is off)";
      allowCommandBlocks = mkEnableOption "Allow command blocks";
    };
    autoPause = {
      enable = mkEnableOption "Autopause";
      timeout = {
        established = mkMcIntOption "time between the last client disconnect and the pausing of the process";
        init = mkMcIntOption "time between server start and the pausing of the process";
        knock = mkMcIntOption "time between knocking of the port (e.g. by the main menu ping) and the pausing of the process";
      };
      period = mkMcIntOption "period of the daemonized state machine, that handles the pausing of the process";
    };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.minecraft = {
      serviceName = "minecraft";
      environment = (lib.internal.attrsets.mergeAttrs (
        let inherit (lib.internal.environment) mkEnv mkEnvRawList mkEnvRaw; in [
          cfg.settings.extraEnv
          (mkEnv "EULA" (lib.trivial.boolToString cfg.settings.eula))
          # Modrinth mod list
          (mkEnvRawList "MODRINTH_PROJECTS" (lib.forEach cfg.modrinth.mods.projects (x: lib.internal.minecraft.translateModName x "modrinth")) "\n")
          (mkEnvRaw "MODRINTH_ALLOWED_VERSION_TYPE" cfg.modrinth.mods.allowedVersionType)
          (mkEnvRaw "MODRINTH_DOWNLOAD_DEPENDENCIES" cfg.modrinth.mods.downloadDependancies)
          # Type and version
          (mkEnv "VERSION" cfg.settings.version)
          (mkEnv "TYPE" cfg.settings.type)
          # API Keys
          (mkEnvRaw "CF_API_KEY" cfg.curseforge.apiKey)
          # Curseforge modpack
          (mkEnv "CF_SLUG" cfg.curseforge.pack.slug)
          (mkEnv "CF_FILE_ID" cfg.curseforge.pack.fileId)
          # Settings
          (mkEnv "MEMORY" ((builtins.toString cfg.settings.memory) + "G"))
          (mkEnvRaw "RCON_CMDS_STARTUP" (lib.strings.concatStringsSep "\n" cfg.settings.rconStartup))
          #(mkEnvRaw "GENERIC_PACK" ( if cfg.settings.extraFiles == null then null else (toString (pkgs.callPackage ./resources/genericPack.nix { src = cfg.settings.extraFiles; }))))
          (mkEnvRaw "GENERIC_PACK" cfg.generic.pack)
          (mkEnvRaw "forge_version" cfg.settings.forgeVersion)
          (mkEnvRaw "FABRIC_LOADER_VERSION" cfg.settings.fabricVersion)
          (mkEnvRaw "MODRINTH_MODPACK" cfg.modrinth.pack.project)
          (mkEnvRaw "MODRINTH_LOADER" cfg.modrinth.pack.loader)
          (mkEnvRaw "MODRINTH_VERSION" cfg.modrinth.pack.version)
          (mkEnvRaw "CUSTOM_SERVER" cfg.settings.customServer)
          (mkEnv "ENABLE_AUTOPAUSE" (lib.trivial.boolToString cfg.autoPause.enable))
          (mkEnv "AUTOPAUSE_TIMEOUT_EST" cfg.autoPause.timeout.established)
          (mkEnv "AUTOPAUSE_TIMEOUT_INIT" cfg.autoPause.timeout.init)
          (mkEnv "AUTOPAUSE_TIMEOUT_KN" cfg.autoPause.timeout.knock)
          (mkEnv "AUTOPAUSE_PERIOD" cfg.autoPause.period)
          (mkEnvRawList "WHITELIST" cfg.settings.whitelist "\n")
          (mkEnvRawList "OPS" cfg.settings.ops "\n")
          (mkEnv "FORCE_GENERIC_PACK_UPDATE" (lib.trivial.boolToString cfg.generic.forceUpdate))
          (mkEnvRawList "JVM_OPTS" cfg.settings.java.args " ")
          (mkEnvRawList "JVM_XX_OPTS" cfg.settings.java.XXargs " ")
          (mkEnvRawList "JVM_DD_OPTS" cfg.settings.java.DDargs " ")
          (mkEnvRawList "CURSEFORGE_FILES" (lib.forEach cfg.curseforge.mods (x: lib.internal.minecraft.translateModName x "curseforge")) "\n")
          (mkEnvRaw "PACKWIZ_URL" cfg.packwiz.url)
          (mkEnv "SPAWN_PROTECTION" cfg.settings.spawnProtection)
          (mkEnv "ALLOW_FLIGHT" (lib.trivial.boolToString cfg.settings.allowFlight))
          (mkEnv "ENABLE_COMMAND_BLOCK" (lib.trivial.boolToString cfg.settings.allowCommandBlocks))
          (mkEnvRaw "STOP_DURATION" (cfg.settings.stopTimeout))
        ]
      ));
      ports = [
        "${builtins.toString cfg.settings.port}:25565"
      ] ++ (lib.optionals (cfg.settings.extraPorts != [ ]) (lib.forEach cfg.settings.extraPorts
        (x:
          (toString (if (x.from != null) then x.from else x.to)) + ":" + (toString x.to) + (if (x.protocol != null) then ("/" + (toString x.protocol)) else "")
        )
      ));
      volumes = [
        "/var/lib/minecraft/data:/data:rw"
        "/var/lib/minecraft/global:/global:ro"
        "/nix/store:/nix/store:ro"
      ];
      # Sets the javaVersion of the image from the respecive values from the attrSet at the begining
      image = "internal/docker-minecraft:${toString cfg.settings.java.version}";
      imageFile = pkgs.internal.dockerMinecraft.override {
        inherit ((import (./resources/minecraft.nix)).versionList.${cfg.settings.java.version}) imageDigest sha256;
        finalImageTag = (toString cfg.settings.java.version);
      };
      autoStart = true;
      extraOptions = (lib.lists.optionals cfg.autoPause.enable [ "--cap-add=CAP_NET_RAW" "--network=slirp4netns:port_handler=slirp4netns" ]);
    };
    systemd.services.minecraft = (mkIf (cfg.settings.stopTimeout != null) {
      preStop = lib.mkForce "podman stop --ignore --cidfile=/run/minecraft/ctr-id -t ${toString cfg.settings.stopTimeout}";
    });
    systemd.tmpfiles.settings."50-minecraft" = {
      "/var/lib/minecraft".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/lib/minecraft/data".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
      };
      "/var/lib/minecraft/global".d = {
        user = "1000";
        group = "1000";
        mode = "1777";
      };
    };
    networking.firewall = {
      allowedTCPPorts = (
        lib.lists.optional cfg.settings.openFirewall cfg.settings.port
        ++
        lib.lists.optionals (cfg.settings.extraPorts != [ ]) (lib.lists.forEach (builtins.filter (x: x.protocol == "tcp") cfg.settings.extraPorts) (x: x.to))
      );
      allowedUDPPorts = (
        lib.lists.optional cfg.settings.openFirewall cfg.settings.port
        ++
        lib.lists.optionals (cfg.settings.extraPorts != [ ]) (lib.lists.forEach (builtins.filter (x: x.protocol == "udp") cfg.settings.extraPorts) (x: x.to))
      );
    };
    assertions = [
      {
        assertion = cfg.settings.eula;
        message = ''
          You need to agree to the Minecraft EULA in order to run the Minecraft Server
          You can read the EULA at https://www.minecraft.net/en-us/eula
          Once you have agreed to the EULA, set `services.minecraft.settings.eula = true` to agree
        '';
      }
      {
        assertion = ! ((lib.strings.hasInfix "alpine" cfg.settings.java.version) && (cfg.generic.pack != null));
        message = ''
          Alpine JVMs do not support generic packs
          These files are Zips, and the alpine container does not have tools to manipulate zip files
          Please change to another JVM version
        '';
      }
    ];
    # Encurage people to not use extraEnv
    warnings = (lib.lists.optional (cfg.settings.extraEnv != { }) ''
      services.minecraft.settings.extraEnv is unsupported
      be sure to check if there is a better way to set values
    '')
    ++
    (lib.lists.optional (lib.lists.any (x: x.from == 25575) cfg.settings.extraPorts) ''
      DO NOT port forward RCON on 25575 without first setting RCON_PASSWORD to a secure value.
      It is highly recommended to only use RCON within the container, such as with rcon-cli
    '');
  };
}
