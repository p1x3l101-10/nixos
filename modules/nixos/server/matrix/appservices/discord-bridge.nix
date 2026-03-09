{ config, globals, ext, ... }:

let
  inherit (globals.server.dns) exists basename;
  tokens = "${globals.dirs.keys}/Matrix/Appservices/Discord/tokens.env";
  dns = "${basename}";
in {
  services.matrix-synapse.settings.app_service_config_files = [
    "/var/lib/matrix-synapse/discord-registration.yaml"
  ];

  services.matrix-appservice-discord = {
    enable = exists;
    environmentFile = tokens;
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
