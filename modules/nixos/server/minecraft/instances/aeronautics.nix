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
          spawnRadius = worldBorderRadius / 10;
          spawnChunkRadius = 0;
        };
      })
      {
        type = "neoforge";
        forgeVersion = "21.1.225";
        version = "1.21.1";
        java = {
          version = "21-graalvm";
          XXargs = [
            "-XX:+UseZGC"
            "-XX:+ZGenerational"
          ];
        };
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
        in (map
          (x: "dwb ${x} set ${wbDiameter}")
          [
            "minecraft:overworld"
            "minecraft:the_end"
            "northstar:earth_orbit"
            "northstar:mercury"
            "northstar:venus"
            "northstar:mars"
            "northstar:moon"
          ]
        ) ++ [
          "dwb minecraft:the_nether set ${wbNetherDiameter}"
        ]);
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/aeronautics".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
