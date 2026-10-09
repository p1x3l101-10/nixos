{ pkgs, eLib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = eLib.attrsets.mergeAttrs [
      (import ../overrides/settings.nix {
        inherit userdata;
        packId = "october-pack";
      })
      {
        type = "forge";
        forgeVersion = "14.23.5.2859";
        version = "1.12.2";
        java.version = "8";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/october-pack".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
