{ config, lib, globals, ... }:

let
  inherit (lib) mkMerge mkIf;
  inherit (globals.dirs) keys state;
in {
  systemd.tmpfiles.settings = {
    "10-nextcloud-permissions" = mkIf config.services.nextcloud.enable {
      "${state}/Servers/Nextcloud/var/lib/nextcloud".Z = {
        user = "nextcloud";
        group = "nextcloud";
      };
      "${keys}/nextcloud/*".Z = {
        user = "nextcloud";
        group = "nextcloud";
      };
    };
    "10-matrix-permissions" = mkIf config.services.matrix-synapse.enable {
      "${state}/Servers/Matrix/var/lib/matrix-synapse".Z = {
        user = "matrix-synapse";
        group = "matrix-synapse";
      };
      "${keys}/Matrix/keys.yaml".Z = {
        user = "matrix-synapse";
        group = "matrix-synapse";
      };
    };
  };
}
