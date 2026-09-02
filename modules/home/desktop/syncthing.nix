{ config, osConfig, eLib, lib, ... }:

let
  mkDevice = (
    { name
    , id
    , folders
    , nixosHostname ? null
    }:
    {
      inherit name id folders nixosHostname;
    }
  );
  mkFolder = (
    { name
    , id
    , path
    , type ? "sendreceive"
    , versioning ? null
    , ignorePatterns ? []
    }:
    {
      inherit name id path type versioning ignorePatterns;
    }
  );
  homeDir = config.home.homeDirectory;
  shortCfg = {
    devices = [
      (mkDevice {
        name = "Stellar PC";
        id = "6OPLJZY-4QTL6OH-PNY27WN-B45TWZ7-R44GROO-SW5KWXP-5MW6DHL-4BHODQQ";
        folders = [
          "Audiobooks"
          "Camera"
          "Default Folder"
          "Documents"
          "Downloads"
          "Games"
          "MC Icons"
          "MC Instances"
          "Music"
          "Oculus"
          "Osu"
          "Phone Misc"
          "Pictures"
          "Starbound Universe"
          "Terraria"
          "Templates"
          "Videos"
        ];
        nixosHostname = "stellar-pc";
      })
      (mkDevice {
        name = "Stellar Laptop";
        id = "AOPAKFA-7ECOBGE-HYROVVS-F2JQY7T-OUYZR4M-B26DLLL-IDXCVQQ-3XFNTAF";
        folders = [
          "Audiobooks"
          "Camera"
          "Default Folder"
          "Documents"
          "Downloads"
          "Games"
          "MC Icons"
          "MC Instances"
          "Music"
          "Oculus"
          "Osu"
          "Phone Misc"
          "Pictures"
          "Starbound Universe"
          "Terraria"
          "Templates"
          "Videos"
        ];
        nixosHostname = "stellar-laptop";
      })
      (mkDevice {
        name = "Steam Deck";
        id = "OFO7QBD-ERD47CK-YEMB4EA-2X7MPYB-SHRWJFK-YQ4GERM-56U2WI7-ITAMVA6";
        folders = [
          "Default Folder"
          "Documents"
          "Downloads"
          "Games"
          "MC Icons"
          "MC Instances"
          "Music"
          "Osu"
          "Pictures"
          "Starbound Universe"
          "Terraria"
          "Videos"
        ];
      })
      (mkDevice {
        name = "Pixel 10 Pro";
        id = "GLIX2WJ-S3JYFO3-342GHQ5-6JN6EYD-HPK3DEG-ZW42UPV-FAFNNAM-5SDODQM";
        folders = [
          "Audiobooks"
          "Camera"
          "Default Folder"
          "Documents"
          "Downloads"
          "Music"
          "Oculus"
          "Phone Misc"
          "Pictures"
          "Videos"
        ];
      })
      (mkDevice {
        name = "Quest 3";
        id = "K4GNSY7-XFID545-KA5SZRI-N32GQPQ-RP5NCAA-3G7L6PF-2QCS5GV-F6SNVA3";
        folders = [
          "Camera"
          "Default Folder"
          "Documents"
          "Downloads"
          "Oculus"
          "Phone Misc"
          "Pictures"
          "Videos"
        ];
      })
    ];
    folders = with config; [
      (mkFolder {
        name = "Audiobooks";
        id = "4xkrg-i9dj1";
        path = "${homeDir}/Audiobooks";
      })
      (mkFolder {
        name = "Camera";
        id = "pixel_6_kjap-photos";
        path = "${homeDir}/Camera";
      })
      (mkFolder {
        name = "Default Folder";
        id = "sn1nr-pcw8m";
        path = "${homeDir}/Sync";
      })
      (mkFolder {
        name = "Documents";
        id = "7t10j-5frar";
        path = xdg.userDirs.documents;
      })
      (mkFolder {
        name = "Downloads";
        id = "rsejh-jym7t";
        path = xdg.userDirs.download;
      })
      (mkFolder {
        name = "Games";
        id = "45aik-9ajyr";
        path = "${homeDir}/Games";
        ignorePatterns = [
          "/ROMs"
        ];
      })
      (mkFolder {
        name =  "MC Icons";
        id = "uefs5-iudgr";
        path = "${xdg.dataHome}/PrismLauncher/icons";
      })
      (mkFolder {
        name = "MC Instances";
        id = "aqg9w-bkdaq";
        path = "${xdg.dataHome}/PrismLauncher/instances";
      })
      (mkFolder {
        name = "Music";
        id = "ly0bl-r2iqi";
        path = xdg.userDirs.music;
      })
      (mkFolder {
        name = "Oculus";
        id = "t5tkm-cvnpk";
        path = "${homeDir}/Oculus";
      })
      (mkFolder {
        name = "Osu";
        id = "yzqvd-3mgat";
        path = "${xdg.dataHome}/osu";
      })
      (mkFolder {
        name = "Phone Misc";
        id = "rx7id-9bfm1";
        path = "${homeDir}/Phone Misc";
      })
      (mkFolder {
        name = "Pictures";
        id = "omyo0-dp5p0";
        path = xdg.userDirs.pictures;
      })
      (mkFolder {
        name = "Starbound Universe";
        id = "atltf-fgcww";
        path = "${xdg.dataHome}/Steam/steamapps/common/Starbound/storage";
      })
      (mkFolder {
        name = "Templates";
        id = "5619q-wqx21";
        path = xdg.userDirs.templates;
      })
      (mkFolder {
        name = "Terraria";
        id = "7wahv-e4ftf";
        path = "${xdg.dataHome}/Terraria";
      })
      (mkFolder {
        name = "Videos";
        id = "qoy8g-azv4o";
        path = xdg.userDirs.videos;
      })
    ];
    globalIgnore = [];
  };
in {
  services.syncthing = {
    enable = true;
    settings = {
      options = {
        relaysEnabled = true;
        localAnnounceEnabled = true;
        limitBandwidthInLan = false;
        urAccepted = 3;
      };
      devices = eLib.attrsets.mergeAttrs (map
        (
          { name
          , id
          , folders
          , nixosHostname
          }:
          if (builtins.isNull nixosHostname) then {
            "${name}" = {
              inherit name id;
            };
          } else (
            #if (nixosHostname == osConfig.networking.hostName) then {} else {
            {
              "${name}" = {
                inherit name id;
              };
            }
          )
        )
        shortCfg.devices
      );
      folders = eLib.attrsets.mergeAttrs (map
        (
          { name
          , id
          , path
          , type
          , versioning
          , ignorePatterns
          }:
          {
            "${name}" = {
              inherit id path type versioning;
              ignorePatterns = shortCfg.globalIgnore ++ ignorePatterns;
              devices = (map
                (x: x.name)
                (builtins.filter
                  (x: ((lib.lists.count (y: y == name) x.folders) > 0) && (x.name != osConfig.networking.hostName))
                  shortCfg.devices
                )
              );
            };
          }
        )
        shortCfg.folders
      );
    };
    overrideDevices = true;
    overrideFolders = true;
    # TODO: Move keys into a dedicated location
    key = null;
    cert = null;
  };
}
