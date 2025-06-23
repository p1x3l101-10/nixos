{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = {
      eula = true;
      type = "forge";
      forgeVersion = "47.4.0";
      version = "1.20.1";
      whitelist = userdata [ "mcUsername" ] (import ./overrides/whitelist.nix);
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
        "datapack disable \"mod:createappliedkinetics\""
      ];
      memory = 8;
      java = {
        version = "17-alpine";
        args = [
          "-javaagent:${builtins.fetchurl {
            url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.1.3/unsup-1.1.3.jar";
            sha256 = "sha256:1386wka7bar1cdd5v7gi0x3pf177phvz3d449m5ybmzza49mmjir";
          }}"
          "-Dunsup.disableReconciliation=true"
          "-Dunsup.bootstrapUrl='https://raw.githubusercontent.com/p1x3l101-10/dylan-bad-lol/refs/heads/main/unsup.ini'" 
          "-Dunsup.bootstrapKey='signify RWRBgYcfobPE7I7STPLaQnp69F06aqQaBSWk0AuUFKlUoCyE6VUZKxJv'"
        ];
      };
      extraEnv = {
        ALLOW_FLIGHT = "TRUE";
        LEVEL_TYPE = "gardenofglass:gardenofglass";
      };
      extraPorts = [
        24454 # Simple voice chat
      ];
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/dylan-bad-lol".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}