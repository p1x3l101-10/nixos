{ pkgs, eLib, userdata, ... }:

let
  worldBorderRadius = 10000;
in {
  services.minecraft = {
    enable = true;
    settings = eLib.attrsets.mergeAttrs [
      (import ../overrides/settings.nix {
        inherit userdata;
        packId = "aeronautics";
        gamerules = {
          playersSleepingPercentage = 101;
          disableElytraMovementCheck = true;
          doImmediateRespawn = true;
          spawnRadius = worldBorderRadius;
          spawnChunkRadius = 0;
        };
      })
      {
        type = "neoforge";
        forgeVersion = "21.1.225";
        version = "1.21.1";
        java.version = "21-graalvm";
      }
      # Make pregenerators work during off-hours
      {
        rcon = {
          startup = [
            "chunky continue"
          ];
          firstConnect = [
            "chunky pause"
          ];
          lastDisconnect = [
            "chunky continue"
          ];
        };
      }
      # Ensure world borders
      {
        rcon.startup = (let
          wbDiameter = builtins.toString (worldBorderRadius * 2);
          wbNetherDiameter = builtins.toString ((worldBorderRadius * 2) / 8);
        in [
          "dwb minecraft:overworld ${wbDiameter}"
          "dwb minecraft:the_nether ${wbNetherDiameter}"
          "dwb minecraft:the_end ${wbDiameter}"
          "dwb iceandfire:dread_land ${wbDiameter}"
          "dwb mahoutsukai:reality_marble ${wbDiameter}"
        ]);
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/aeronautics".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
