{ eLib, userdata, lib, ... }:

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
        customServer = "https://github.com/GTNewHorizons/lwjgl3ify/releases/download/3.0.16/lwjgl3ify-3.0.16-forgePatches.jar";
        levelType = "rwg";
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
  systemd.services."gtnh-setup" = {
    before = [ "minecraft.service" ];
    requiredBy = [ "minecraft.service" ];
    script = let
      destDir = "/var/lib/minecraft/data";
      serverFiles = builtins.fromJSON (builtins.readFile ./support/gtnh-serverFiles.json);
      downloadFile = dest: url: ''curl "${url}" > "${destDir}/${dest}"'';
    in ''
      if [[ ! -f "${destDir}/java9args.txt" ]]; then
    '' + (builtins.concatStringsSep
      "\n"
      ((lib.mapAttrsToList
        (k: v: downloadFile k v)
        serverFiles
      )
      ++ [ "fi" ])
    );
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/GTNH".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
