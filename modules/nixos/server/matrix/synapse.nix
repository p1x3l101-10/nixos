{ globals, config, lib, ... }:

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
      logging.level = "DEBUG";
      server_name = config.networking.domain;
      public_baseurl = baseUrl;
      presence.enabled = true;
      allow_public_rooms_over_federation = true;
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
              ];
              compress = true;
            }
          ];
        }
      ];
    };
  };
}
