{ config, globals, ext, ... }:

let
  inherit (globals.server.dns) exists basename;
  tokens = "${globals.dirs.keys}/Matrix/Appservices/Discord/tokens.env";
  dns = "${basename}";
in {
  services.matrix-synapse.settings.app_service_config_files = [
    # The registration file is automatically generated after starting the
    # appservice for the first time.
    # cp /var/lib/matrix-appservice-discord/discord-registration.yaml \
    #   /var/lib/matrix-synapse/
    # chown matrix-synapse:matrix-synapse \
    #   /var/lib/matrix-synapse/discord-registration.yaml
    "/var/lib/matrix-synapse/discord-registration.yaml"
  ];

  services.matrix-appservice-discord = {
    enable = exists;
    environmentFile = tokens;
    # The appservice is pre-configured to use SQLite by default.
    # It's also possible to use PostgreSQL.
    settings = {
      bridge = {
        domain = dns;
        homeserverUrl = "https://matrix.${dns}";
        adminMxid = "pixel@${dns}";
      };
      auth = {
        clientID = "1470849103565951077";
        usePrivilegedIntents = true;
      };

      # The service uses SQLite by default, but it's also possible to use
      # PostgreSQL instead:
      #database = {
      #  filename = ""; # empty value to disable sqlite
      #  connString = "socket:/run/postgresql?db=matrix-appservice-discord";
      #};
    };
    # FIXME
    ## Why: Build Failure
    ## Description: Upstream has removed `passthru.nodeAppDir` in the unstable package without updating the module
    ## Action: revert to current stable version of package
    ## Resolution: Upstream module update
    ## Resolution (Extended):
    ### Monitor <nixpkgs>/nixos/modules/services/matrix/appservice-discord.nix:147:46 For updated module not needing passthru.nodeAppDir
    package = ext.stable.pkgs.matrix-appservice-discord;
  };
}
