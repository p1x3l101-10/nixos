{ eLib, userdata, ... }:

{
  services.minecraft = {
    enable = true;
    settings = eLib.attrsets.mergeAttrs [
      (import ../overrides/settings.nix { inherit userdata; })
      {
        java.args = (import ../overrides/unsup.nix {
          url = "https://p1x3l101-10.github.io/gtnh2packwiz-ng/patched/unsup.ini";
        });
      }
      {
        type = "custom";
        java = {
          version = "21-graalvm";
          args = [
            "-Dfml.readTimeout=180"
            "@java9args.txt"
          ];
        };
        version = "1.7.10";
        memory = 20;
        port = 25565;
        rcon.startup = [
          "bq_admin default load" # Reload for updates
          "difficulty hard"
        ];
        customServer = "lwjgl3ify-forgePatches.jar";
        levelType = "rwg";
        applyExtraFiles = (builtins.fromJSON (builtins.readFile ./support/gtnh-serverFiles.json)) // {
          "lwjgl3ify-forgePatches.jar" = "https://github.com/GTNewHorizons/lwjgl3ify/releases/download/3.0.16/lwjgl3ify-3.0.16-forgePatches.jar";
        };
      }
    ];
  };
  virtualisation.oci-containers.containers.minecraft = {
    cmd = [
      "--stop-timeout" "-1" # Prevent container from being killed when stopping
    ];
    volumes = [
      "/var/lib/minecraft/backups:/backups:rw" # Serverutilities backups
    ];
  };
  # Make a data folder to mount to
  systemd.tmpfiles.settings."50-minecraft" = {
    "/var/lib/minecraft/backups".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/GTNH".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
