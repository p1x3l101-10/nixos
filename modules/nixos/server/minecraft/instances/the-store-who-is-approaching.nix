{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = {
      eula = true;
      type = "forge";
      forgeVersion = "47.4.10";
      version = "1.20.1";
      whitelist = userdata [ "mcUsername" ] (import ../overrides/whitelist.nix);
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
      memory = 8;
      java = {
        version = "17-graalvm";
        args = [
          "-javaagent:${builtins.fetchurl {
            url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.1.3/unsup-1.1.3.jar";
            sha256 = "sha256:1386wka7bar1cdd5v7gi0x3pf177phvz3d449m5ybmzza49mmjir";
          }}"
          "-Dunsup.disableReconciliation=true"
          "-Dunsup.bootstrapUrl=file://${pkgs.writeText "unsup.ini" (lib.generators.toINIWithGlobalSection {} {
            globalSection = {
              version = 1;
              source = "file://${./the-store-who-is-approaching}/pack.toml";
              source_format = "packwiz";
              preset = "minecraft";
              behavior = "auto";
            };
          })}"
        ];
      };
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/the-store-who-is-approaching".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
