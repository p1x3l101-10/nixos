{ osConfig, lib, config, ... }:

let
  inherit (osConfig.networking) hostName;
  normalDevices = {
    deck = {
      name = "Steam Deck";
      id = "OFO7QBD-ERD47CK-YEMB4EA-2X7MPYB-SHRWJFK-YQ4GERM-56U2WI7-ITAMVA6";
    };
    macbook = {
      name = "School MacBook Air";
      id = "3TR2UN5-A6VZAM7-TH6OGRS-B3Y2KJF-REGLPET-T72TP5Y-J63274F-74XX2QH";
    };
    phone = {
      name = "Pixel 10 Pro";
      id = "GLIX2WJ-S3JYFO3-342GHQ5-6JN6EYD-HPK3DEG-ZW42UPV-FAFNNAM-5SDODQM";
    };
    quest = {
      name = "Quest";
      id = "K4GNSY7-XFID545-KA5SZRI-N32GQPQ-RP5NCAA-3G7L6PF-2QCS5GV-F6SNVA3";
    };
  };
  nixosDevices = {
    pixels-pc = {
      name = "Pixels PC";
      id = "6OPLJZY-4QTL6OH-PNY27WN-B45TWZ7-R44GROO-SW5KWXP-5MW6DHL-4BHODQQ";
    };
  };
  otherNixosDevices = (lib.filterAttrs
    (n: v: (n != hostName))
    nixosDevices
  );
  me = if (hostName == "pixels-pc") then
    nixosDevices.pixels-pc
  else (builtins.throw "Unset device name in syncthing!");
  devices = normalDevices // otherNixosDevices;
  getIds = devices: (builtins.filter
    (x: (x != me.id))
    (map 
      (x: x.id)
      devices
    )
  );
  trimFirstTwo = str: (builtins.substring 2 (builtins.stringLength str - 2) str);
  globalIgnorePatterns = ''
    (?d).DS_Store
    (?d).Spotlight-V100
    (?d).Trashes
    (?d)desktop.ini
    (?d)Thumbs.db
  '';
  folders = {
    Audiobooks = {
      devices = getIds (with devices; [
        macbook
        phone
        pixels-pc
      ]);
      path = "~/Audiobooks";
      id = "4xkrg-i9dj1";
      ignore = '''';
    };
    Camera = {
      devices = getIds (with devices; [
        phone
        quest
        macbook
        pixels-pc
      ]);
      path = "~/Camera";
      id = "pixel_6_kjap-photos";
      ignore = '''';
    };
    "Default Folder" = {
      devices = getIds (with devices; [
        phone
        quest
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Sync";
      id = "sn1nr-pcw8m";
      ignore = '''';
    };
    Documents = {
      devices = getIds (with devices; [
        phone
        quest
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Documents";
      id = "7t10j-5frar";
      ignore = '''';
    };
    Downloads = {
      devices = getIds (with devices; [
        phone
        quest
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Downloads";
      id = "rsejh-jym7t";
      ignore = '''';
    };
    Games = {
      devices = getIds (with devices; [
        deck
        pixels-pc
      ]);
      path = "~/Games";
      id = "45aik-9ajyr";
      ignore = ''
        /ROMs
      '';
    };
    Music = {
      devices = getIds (with devices; [
        phone
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Music";
      id = "ly0bl-r2iqi";
      ignore = '''';
    };
    Oculus = {
      devices = getIds (with devices; [
        phone
        quest
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Oculus";
      id = "t5tkm-cvnpk";
      ignore = '''';
    };
    "Phone Misc" = {
      devices = getIds (with devices; [ 
        pixels-pc 
        phone 
        quest
      ]);
    };
    Pictures = {
      devices = getIds (with devices; [
        phone
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Pictures";
      id = "omyo0-dp5p0";
      ignore = '''';
    };
    RetroDECK = {
      devices = getIds (with devices; [
        deck
        pixels-pc
      ]);
      path = "~/RetroDECK";
      id = "retro-data";
      ignore = '''';
    };
    Videos = {
      devices = getIds (with devices; [
        phone
        deck
        macbook
        pixels-pc
      ]);
      path = "~/Videos";
      id = "qoy8g-azv4o";
      ignore = '''';
    };
  };
in {
  services.syncthing = {
    enable = true;
    cert = "/nix/host/keys/syncthing/cert.pem";
    key = "/nix/host/keys/syncthing/key.pem";
    settings = {
      inherit devices;
      folders = (builtins.mapAttrs (n: v: { inherit (v) devices path id; }) folders);
      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = "2";
      };
    };
  };
  home.file = (lib.mapAttrs'
    (n: v: {
      name = (trimFirstTwo v.path) + "/.stignore";
      value = {
        text = builtins.concatStringsSep "\n" [ globalIgnorePatterns v.ignore ];
      };
    })
    folders
  );
  systemd.user.tmpfiles.rules = (lib.mapAttrsToList
    (n: v: "d ${config.home.homeDirectory}/${trimFirstTwo v.path}/.stfolder 0755 ${config.home.username} users - -")
    folders
  );
}
