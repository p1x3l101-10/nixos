{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = {
      eula = true;
      type = "forge";
      version = "1.12.2";
      forgeVersion = "14.23.5.2860";
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
      java = {
        version = "8";
        args = [
          "-javaagent:${builtins.fetchurl {
            url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.1-beta1/unsup-1.1-beta1.jar";
            sha256 = "sha256:0xa2zdfb9v1qgrxw7d45vca8ygsgrjd5x2xbmxz7v0s3b2ywr1zx";
          }}"
          "-Dunsup.disableReconciliation=true"
        ];
      };
      spawnProtection = 0;
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/tinkering-2".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}