{ config, lib, globals, ... }:

let
  inherit (lib) mkMerge mkIf;
  inherit (globals.dirs) keys state;
in {
  systemd.tmpfiles.settings = {
    "10-nextcloud-permissions" = mkIf config.services.nextcloud.enable {
      "${state}/Servers/Nextcloud/var/lib/nextcloud/*".e = {
        user = "nextcloud";
        group = "nextcloud";
      };
      "${keys}/nextcloud/*".e = {
        user = "nextcloud";
        group = "nextcloud";
      };
    };
    "10-matrix-permissions" = mkIf config.services.matrix-synapse.enable {
      "${state}/Servers/Matrix/var/lib/matrix-synapse/*".e = {
        user = "matrix-synapse";
        group = "matrix-synapse";
      };
      "${keys}/Matrix/keys.yaml".e = {
        user = "matrix-synapse";
        group = "matrix-synapse";
      };
    };
    "10-email-permissions" = mkIf config.services.maddy.enable {
      "${state}/Servers/EMail/var/lib/maddy/*".e = {
        user = "maddy";
        group = "maddy";
      };
      "${state}/Servers/EMail/var/lib/rspamd/*".e = {
        user = "rspamd";
        group = "rspamd";
      };
      "${keys}/email/*".e = {
        user = "maddy";
        group = "maddy";
      };
    };
  };
}
