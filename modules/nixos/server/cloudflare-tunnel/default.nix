{ globals, config, ... }:

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
        ingress = {
          "*.${globals.server.dns.basename}" = "http://localhost:443";
        };
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
