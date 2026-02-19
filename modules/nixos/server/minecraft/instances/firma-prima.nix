{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = lib.internal.attrsets.mergeAttrs [
      (import ../overrides/settings.nix {
        inherit userdata;
        packId = "firma-prima";
      })
      {
        type = "forge";
        forgeVersion = "47.4.10";
        version = "1.20.1";
        java.version = "17-graalvm";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/firma-prima".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
