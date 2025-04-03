{ pkgs, lib, ... }:
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
  system.allowlistedLicenses.packages = [ "steam-unwrapped" ];
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
  } // {
    "/var/lib/flatpak/repo/config".C = {
      user = "root";
      group = "root";
      mode = "0777";
      argument = builtins.toString (pkgs.writeText "flatpak-config" ''
        [core]
        repo_version=1
        mode=bare-user-only
        min-free-space-size=500MB
      '');
    };
  };
}
