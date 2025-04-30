{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    packwiz.url = "https://raw.githubusercontent.com/p1x3l101-10/i-know-what-we-are-going-to-do-today/refs/heads/main/pack.toml";
    settings = {
      eula = true;
      type = "forge";
      version = "1.16.5";
      whitelist = userdata [ "mcUsername" ] [
          "cayden"
          "spradley"
          "scott"
          "dylan"
          "kenton"
      ];
      ops = userdata [ "mcUsername" ] [
          "scott"
      ];
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
      memory = 8;
      java.version = "17";
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/tinkering-2".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}