{ pkgs, ... }:

{
  services.minecraft = {
    enable = true;
    modrinth = {
      mods = {
        projects = [
          "create"
          "almost-unified"
          "emi"
          "emi-ores"
          "jei"
          "lithium"
          "appleskin"
          "modernfix"
          "ferrite-core"
          "elytra-trims"
          "do-a-barrel-roll"
          "no-chat-reports"
          "corpse"
          { dataPack = true; modId = "create-stones"; }
          { dataPack = true; modId = "create-renewable-diamonds"; }
          { dataPack = true; modId = "create-renewable-netherite"; }
          "create-copper-zinc"
          "simplest-copper-gear"
          "simplest-paxels"
          "simplest-hammers"
          "simplest-excavators"
          "emi-loot"
          "jade"
          "jade-addons-forge"
          { dataPack = true; modId = "dynamic-lights"; }
          "natures-compass"
          "explorers-compass"
          "travelers-compass"
          "create-trimmed"
          "create-ranged"
          "create-ore-excavation"
          "create_oxidized"
          # Addons to wait on:
          /*
          TFMG
          Enchantment industry
          Central Kitchen
          Jetpack
          Big cannons
          TIS-3D
          TIS-Create
          TIS-Advanced
          Some create chunkloader mod
          liquid fuel?
          */
        ];
        downloadDependancies = "required";
        allowedVersionType = "beta";
      };
    };
    settings = {
      version = "1.21.1";
      eula = true;
      java.version = "21-alpine";
      type = "neoforge";
      memory = 8;
      port = 25565;
      openFirewall = true;
      whitelist = getdata [ "mcUsername" ] (import ./overrides/whitelist.nix);
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/create-smp".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}