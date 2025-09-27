{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = lib.internal.attrsets.mergeAttrs [
      (import ./overrides/settings.nix {
        inherit userdata;
        packId = "skyblock";
      })
      {
        type = "forge";
        forgeVersion = "47.4.0";
        version = "1.12.2";
        java.version = "8";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/totallySkyblock".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
