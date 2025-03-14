{ lib, ... }:
let
  mkTmp = { baseDir, permissions, subdirs ? []}: builtins.listToAttrs (
    [ { name = baseDir; value = { d = permissions; }; } ] ++
    lib.lists.forEach subdirs (x:
      lib.attrsets.nameValuePair "${baseDir}/${x}" { d = permissions; }
    )
  );
in {
  services.flatpak.enable = true;
  hardware.steam-hardware.enable = true;
  # Fix dir permissions
  systemd.tmpfiles.settings."99-permission-fixes" = mkTmp {
    baseDir = "/var/lib/flatpak";
    permissions = {
      user = "root";
      group = "root";
      mode = "0777";
    };
    subdirs = [
      "repo"
      "repo/objects"
      "repo/tmp"
    ];
  };
}
