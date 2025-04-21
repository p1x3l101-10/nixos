{ pkgs, lib, ... }:

let
  fetchGHRelease = { owner, repo, version, fileName, hash }: pkgs.fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${version}/${fileName}";
    inherit hash;
  };
  getdata = key: names: (import ../userdata.nix { inherit lib; }).getdata key names;
in {
  services.minecraft = {
    enable = true;
    generic = {
      forceUpdate = true;
      pack = builtins.toString (lib.internal.builders.genericPack {
        packList = [
          ./overrides/gtnh
          (lib.internal.builders.genericMod rec {
            name = "ocwasm";
            version = "1.7.10-0.5.2";
            file = fetchGHRelease {
              fileName = "${name}-${version}.jar";
              inherit version;
              owner = "DCNick3";
              repo = "OC-Wasm-GTNH";
              hash = "sha256-sMMdWxKBQCqtijxLos7GYjlxHtrsFfh+XzTjTcabnek=";
            };
          })
          (pkgs.fetchzip {
            url = "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_2.7.4_Server_Java_17-21.zip";
            hash = "sha256-wWGDbVwVe6989SyPjS0d/82oXTu//rHkDbjIVzFAVgY=";
            stripRoot=false;
          })
        ];
      });
    };
    settings = {
      eula = true;
      type = "custom";
      java = {
        version = "21-graalvm";
        args = [
          "-Dfml.readTimeout=180"
          "@java9args.txt"
        ];
      };
      version = "1.7.10";
      memory = 8;
      port = 25565;
      rconStartup = [
        "bq_admin default load" # Reload for updates
        "bq_admin hardcore true"
        "difficulty hard"
      ];
      customServer = "lwjgl3ify-forgePatches.jar";
      whitelist = getdata [ "mcUsername" ] (import ./overrides/whitelist.nix);
    };
  };
  virtualisation.oci-containers.containers.minecraft.volumes = [
    "/var/lib/minecraft/backups:/backups:rw" # Serverutilities backups
  ];
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
