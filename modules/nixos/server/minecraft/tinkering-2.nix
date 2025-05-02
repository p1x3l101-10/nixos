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
            url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.1-pre9/unsup-1.1-pre9.jar";
            sha256 = "sha256:fd17f95dd938399bfbd31e7b04d7a04dc62ebecc43b8b6ae3863890c429aead7";
          }}"
        ];
      };
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/tinkering-2".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}