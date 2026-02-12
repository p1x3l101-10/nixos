{ globals, config, lib, pkgs, ... }:

let
  inherit (globals.server.dns) exists basename;
  inherit (lib.internal.webserver) mkWellKnown;
  fqdn = "matrix.${config.networking.domain}";
  baseUrl = "https://${fqdn}";
  inherit (import ./config.nix { inherit lib; matrix_fqdn = fqdn; }) serverConfig clientConfig;
in {
  services.postgresql.enable = true;
  services.nginx.virtualHosts = {
    # Add /.well-known entry
    "${basename}" = {
      locations."/.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
      locations."/.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
    };
    "${fqdn}" = {
      enableACME = true;
      onlySSL = true;
      # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
      # *must not* be used here.
      locations."/_matrix".proxyPass = "http://[::1]:8008";
      # Forward requests for e.g. SSO and password-resets.
      locations."/_synapse/client".proxyPass = "http://[::1]:8008";
    };
  };
  services.matrix-synapse = {
    enable = exists;
    extraConfigFiles = [
      "${globals.dirs.keys}/Matrix/keys.yaml"
    ];
    settings = {
      logging.level = "INFO";
      server_name = config.networking.domain;
      default_identity_server = config.services.matter-synapse.settings.server_name;
      public_baseurl = baseUrl;
      presence.enabled = true;
      allow_public_rooms_over_federation = true;
      enable_search = true;
      allow_per_room_profiles = true;
      allowed_avatar_mimetypes = [
        "image/png"
        "image/jpeg"
        "image/gif"
      ];
      auto_join_rooms = [];
      user_directory = {
        enabled = true;
        prefer_local_users = true;
        search_all_users = true;
      };
      server_notices = {
        system_mxid_localpart = "notices";
        system_mxid_display_name = "Server Notices";
        room_name = "Server Notices";
        auto_join = true;
      };
      enable_room_list_search = true;
      # Enable registration, but require a token to do so
      enable_registration = true;
      registration_requires_token = true;
      # https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html#prevent_media_downloads_from
      prevent_media_downloads_from = [];
      # https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html#url_preview_url_blacklist
      url_preview_url_blacklist = [];
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
                "keys"
                "media"
                "health"
              ];
              compress = true;
            }
          ];
        }
      ];
      experimental_features = {
        # Room summary API
        msc3266_enabled = true;
        # syncv2 state after, allows better room state tracking
        msc4442_enabled = true;
      };
      max_event_delay_duration = "24h";
      rc_message = {
        per_second = 0.5;
        burst_count = 30;
      };
      rc_delayed_event_mgmt = {
        per_second = 1;
        burst_count = 20;
      };
    };
  };
  # Add tool
  users.users."matrix-synapse".packages = with pkgs; [
    synadm
  ];
}
