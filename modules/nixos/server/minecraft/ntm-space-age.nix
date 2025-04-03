{ pkgs, lib, ... }:

let
  fetchGHRelease = { owner, repo, version, fileName, hash }: pkgs.fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${version}/${fileName}";
    inherit hash;
  };
  fetchGTNHMod = { repo, name, version, hash }: fetchGHRelease {
    owner = "GTNewHorizons";
    fileName = "${name}-${version}.jar";
    inherit repo version hash;
  };
  GTNHGenericMod = { repo, name, version, hash }: lib.internal.builders.genericMod {
    inherit name version;
    file = fetchGTNHMod { inherit repo name version hash; };
  };
  lwjgl3ify-forgePatches = pkgs.stdenvNoCC.mkDerivation rec {
    name = "lwjgl3ify-forgePatches";
    version = "2.1.9";
    src = pkgs.fetchurl {
      url = "https://github.com/GTNewHorizons/lwjgl3ify/releases/download/${version}/lwjgl3ify-${version}-forgePatches.jar";
      hash = "sha256-Wn02CV98S5wrw3LhX4TB+JfOzjUDVT+kk32q2+0TTCY=";
    };
    sourceRoot = ".";
    unpackPhase = ''
      cp ${src} "./${src.name}"
    '';
    installPhase = ''
      mkdir -p $out
      mv ./${src.name} $out/lwjgl3ify-forgePatches.jar
    '';
  };
in {
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (lib.internal.builders.genericPack {
      packList = [
        ./overrides/ntm-space-age
        lwjgl3ify-forgePatches
        (lib.internal.builders.genericMod rec {
          name = "Thistle";
          version = "1.7.10-1.1.0";
          file = fetchGHRelease {
            fileName = "${name}-${version}.jar";
            owner = "BlueAmulet";
            repo = name;
            version = "v1.1.0";
            hash = "sha256-cRKuDNNDaEHDFQPNPHeIs/SySpKdoLgzv2ojl5fFqQs=";
          };
        })
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
        (GTNHGenericMod {
          name = "appliedenergistics2";
          version = "rv3-beta-549-GTNH";
          repo = "Applied-Energistics-2-Unofficial";
          hash = "sha256-Uh9r5+HTTRPVqTFvsKx40ucEX8YTrzIvCeimGwSZMaA=";
        })
        (GTNHGenericMod rec {
          name = "ae2stuff";
          version = "0.9.4-GTNH";
          repo = name;
          hash = "sha256-+QWYZ1fT43aM9BWUVvwojB6RXORjCt7n6I+1HBezGvY=";
        })
        (GTNHGenericMod rec {
          name = "NotEnoughEnergistics";
          version = "1.7.0";
          repo = name;
          hash = "sha256-h4nZ+U03r8jPCZEzzH83yt7FPcM9V7ERpEgqmLglMrE=";
        })
      ];
    });
    modrinth.mods = {
      projects = [
        "ntmspace"
        "notenoughids-unofficial"
        "gtnhlib"
        "lwjgl3ify"
      ];
      allowedVersionType = "beta";
    };
    curseforge = {
      mods = [
        "70496"
        { modId = 746279; versionId = 6070102; }
        "230976"
        "384391"
        "358228"
        "1099276"
        "238603"
        "227639"
        "244258"
        "826970"
        "73488"
        "235140"
        "227875"
        "238551"
        "225819"
        "223008"
        "236839"
        "225225"
        "225127"
        "231687"
        "267909"
      ];
      apiKey = import ./overrides/cfApiKey.nix;
    };
    settings = {
      eula = true;
      type = "custom";
      java = {
        version = "21-graalvm";
        args = [
          "@${builtins.fetchurl {
            url = "https://raw.githubusercontent.com/GTNewHorizons/lwjgl3ify/refs/heads/master/java9args.txt";
            sha256 = "sha256:0mvlkwbi9v1dxir1fj9vrd2liwlakqzmajl4grwwg6ynb1qw2jai";
          }}"
        ];
      };
      customServer = "lwjgl3ify-forgePatches.jar";
      version = "1.7.10";
      memory = 8;
      rconStartup = [
        "difficulty hard"
      ];
      whitelist = getdata [ "mcUsername" ] (import ./overrides/whitelist.nix);
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/ntm-space-age".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}