{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    packwiz.url = "https://raw.githubusercontent.com/p1x3l101-10/i-know-what-we-are-going-to-do-today/refs/heads/main/pack.toml";
    settings = {
      eula = true;
      type = "forge";
      forgeVersion = "47.4.0";
      version = "1.20.1";
      whitelist = userdata [ "mcUsername" ] [
          "cayden"
          "spradley"
          "scott"
          "dylan"
          "kenton"
      ];
      ops = userdata [ "mcUsername" ] [
          "scott"
          "spradley"
      ];
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
      memory = 8;
      java = {
        version = "8";
        args = [
          "-javaagent:${builtins.fetchurl {
            url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.1-beta1/unsup-1.1.3.jar";
            sha256 = lib.fakeHash;
          }}"
          "-Dunsup.disableReconciliation=true"
          "-Dunsup.bootstrapUrl='https://raw.githubusercontent.com/p1x3l101-10/dont-dye-together/refs/heads/main/unsup.ini'" 
          "-Dunsup.bootstrapKey='signify RWRBgYcfobPE7I7STPLaQnp69F06aqQaBSWk0AuUFKlUoCyE6VUZKxJv'"
        ];
      };
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/tinkering-2".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}