{ pkgs, eLib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = eLib.attrsets.mergeAttrs [
      (import ../overrides/settings.nix {
        inherit userdata;
        packId = "aeronautics";
        gamerules = {
          playersSleepingPercentage = 50;
          disableElytraMovementCheck = true;
          doImmediateRespawn = true;
          spawnRadius = 100;
          spawnChunkRadius = 0;
        };
      })
      {
        type = "neoforge";
        forgeVersion = "21.1.248";
        version = "1.21.1";
        java = {
          version = "21-graalvm";
          XXargs = [
            "-XX:+UseZGC"
            "-XX:+ZGenerational"
            "-Dchunky.maxWorkingCount=76"
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
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/aeronautics".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
