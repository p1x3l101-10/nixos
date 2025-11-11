{ pkgs, lib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = lib.internal.attrsets.mergeAttrs [
      (import ./overrides/settings.nix {
        inherit userdata;
        packId = "magical-meat";
      })
      {
        type = "fabric";
        forgeVersion = "0.18.0";
        version = "1.20.1";
        java.version = "17-alpine";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/magical-meat".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
