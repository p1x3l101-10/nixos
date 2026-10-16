{ eLib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    curseforge.pack = {
      slug = "techrpg";
      fileId = "8643011";
    };
    settings = eLib.attrsets.mergeAttrs [
      (import ../overrides/settings.nix {
        inherit userdata;
      })
      {
        ops = userdata [ "mcUsername" ] [ "spradley" ];
        type = "auto_curseforge";
        java.version = "17";
      }
    ];
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/techrpg".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
