{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = lib.internal.attrsets.mergeAttrs [
      (import ./overrides/settings.nix {
        inherit userdata;
        packId = "botany";
      })
      {
        type = "forge";
        forgeVersion = "47.4.0";
        version = "1.20.1";
        java.version = "17-alpine";
        extraPorts = [
          24454 # Simple voice chat
        ];
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/botany".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
