{ globals, config, lib, ... }:

let
  tunnelId = "17af68d2-548a-4428-9e42-fcfd85a452c1";
in {
  services.cloudflared = {
    enable = globals.server.dns.exists;
    certificateFile = "${globals.dirs.keys}/cloudflared/cert.pem";
    tunnels = {
      "${tunnelId}" = {
        credentialsFile = "${globals.dirs.keys}/cloudflared/${tunnelId}.json";
        default = "http_status:404";
        ingress = (lib.mapAttrs' (
          (k: v: lib.nameValuePair ("${k}.${globals.server.dns.basename}") ("https://localhost:${builtins.toString v}"))
          {
            srv03 = 443;
            cdn = 443;
            nextcloud = 443;
          }
        ) // {
          "${globals.server.dns.basename}" = "https://localhost:443";
        });
      };
    };
  };
  services.openssh.settings.Macs = [
    # Defaults
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    # cloudflared needed for browser rendering
    "hmac-sha2-256"
  ];
}
