{ globals, config, lib, eLib, ... }:

let
  tunnelId = "17af68d2-548a-4428-9e42-fcfd85a452c1";
  getProto = port: eLib.lists.switch [
    { case = 80; out = "http"; }
    { case = 443; out = "https"; }
    { case = 22; out = "ssh"; }
  ] "tcp";
in {
  services.cloudflared = {
    enable = globals.server.dns.exists;
    certificateFile = "${globals.dirs.keys}/cloudflared/cert.pem";
    tunnels = {
      "${tunnelId}" = {
        credentialsFile = "${globals.dirs.keys}/cloudflared/${tunnelId}.json";
        default = "http_status:404";
        ingress = (lib.mapAttrs'
          (k: v: lib.nameValuePair ("${k}.${globals.server.dns.basename}") ("${getProto v}://localhost:${builtins.toString v}"))
          {
            srv03 = 80;
            cdn = 443;
            nextcloud = 443;
          }
        );
        default = "https://localhost:443";
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
