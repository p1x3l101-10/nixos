{ pkgs, eLib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = eLib.attrsets.mergeAttrs [
      (import ../overrides/settings.nix {
        inherit userdata;
        packId = "aeronautics";
      })
      {
        type = "neoforge";
        forgeVersion = "21.1.225";
        version = "1.21.1";
        java.version = "21";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/aeronautics".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
