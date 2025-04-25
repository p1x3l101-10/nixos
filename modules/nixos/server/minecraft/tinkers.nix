{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    generic = {
      forceUpdate = true;
      pack = builtins.toString (lib.internal.builders.genericPack {
        packList = [
          (pkgs.fetchzip {
            url = "https://pixeldrain.com/api/file/Ly4psV1s";
            hash = lib.fakeHash;
            extension = "zip";
          })
        ];
      });
    };
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