{ osConfig, lib, ... }:

let
  inherit (osConfig.networking) hostName;
  normalDevices = {
    macbook = {
      name = "School MacBook Air";
      id = "3TR2UN5-A6VZAM7-TH6OGRS-B3Y2KJF-REGLPET-T72TP5Y-J63274F-74XX2QH";
    };
    phone = {
      name = "Pixel 10 Pro";
      id = "GLIX2WJ-S3JYFO3-342GHQ5-6JN6EYD-HPK3DEG-ZW42UPV-FAFNNAM-5SDODQM";
    };
  };
  nixosDevices = {
    pixels-pc = {
      name = "Pixels PC";
      id = "";
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
  allPublicDevices = with devices [
    macbook
    phone
    pixels-pc
  ];
in {
  services.syncthing = {
    enable = true;
    cert = "/nix/host/keys/syncthing/cert.pem";
    key = "/nix/host/keys/syncthing/key.pem";
    settings = {
      inherit devices;
      folders = {
        Audiobooks = {
          devices = getIds allPublicDevices;
          path = "~/Audiobooks";
          id = "4xkrg-i9dj1";
        };
        Camera = {
          devices = getIds allPublicDevices;
          path = "~/Camera";
          id = "pixel_6_kjap-photos";
        };
        "Default Folder" = {
          devices = getIds allPublicDevices;
          path = "~/Sync";
          id = "sn1nr-pcw8m";
        };
        Documents = {
          devices = getIds allPublicDevices;
          path = "~/Documents";
          id = "7t10j-5frar";
        };
        Downloads = {
          devices = getIds allPublicDevices;
          path = "~/Downloads";
          id = "rsejh-jym7t";
        };
        Music = {
          devices = getIds allPublicDevices;
          path = "~/Music";
          id = "ly0bl-r2iqi";
        };
        Oculus = {
          devices = getIds allPublicDevices;
          path = "~/Oculus";
          id = "t5tkm-cvnpk";
        };
        Pictures = {
          devices = getIds allPublicDevices;
          path = "~/Pictures";
          id = "omyo0-dp5p0";
        };
        Videos = {
          devices = getIds allPublicDevices;
          path = "~/Videos";
          id = "qoy8g-azv4o";
        };
      };
      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = "2";
      };
    };
  };
}
