{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = lib.internal.attrsets.mergeAttrs [
      (import ./overrides/settings.nix {
        inherit userdata;
        packId = "dylan-bad-lol";
      })
      {
        type = "forge";
        forgeVersion = "47.4.0";
        version = "1.20.1";
        java.version = "17-alpine";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/dylan-bad-lol".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}