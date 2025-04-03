{ lib, ext }:

folderList:

let
  defaultDir = {
    user = "root";
    group = "root";
    mode = "0700";
  };
  defaultFile = {
    user = "root";
    group = "root";
    mode = "0400";
    argument = "CHANGEME";
  };
in
lib.attrsets.mergeAttrsList ([
  {
    systemd.tmpfiles.settings."10-host-keys" = {
      "/nix/host/keys/minio" = {
        d = defaultDir;
        Z = defaultDir; # Enforce permissions even on other files
      };
      "/nix/host/keys/minio/**/*.psk".Z = defaultFile; # Enforce permissions
    };
  }
] ++ (lib.lists.forEach folderList (f:
  {
    systemd.tmpfiles.settings."10-host-keys" = {
      "/nix/host/keys/minio/keys/${f}".d = defaultDir;
      "/nix/host/keys/minio/keys/${f}/${f}.psk".f = defaultFile;
    };
  }
)))