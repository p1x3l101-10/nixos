{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = {
      eula = true;
      type = "forge";
      version = "1.12.2";
      whitelist = userdata [ "mcUsername" ] [
          "cayden"
          "spradley"
          "scott"
          "dylan"
      ];
      ops = userdata [ "mcUsername" ] [
          "spradley"
          "scott"
      ];
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
      memory = 8;
      java.version = "8";
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/tinkers".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}