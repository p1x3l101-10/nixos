{ globals, config, ... }:

{
  services.cloudflared = {
    enable = globals.server.dns.exists;
    certificateFile = "${globals.dirs.keys}/cloudflared/cert.pem";
    tunnels = {
      "d164644e-64b8-6d50-dd06-5ef63f334c99" = {
        certificateFile = "${globals.dirs.keys}/cloudflared/d164644e64b86d50dd065ef63f334c99.pem";
        default = "http_status:404";
        ingress = {
          "*.${globals.server.dns.basename}" = "http://localhost:443";
        };
      };
    };
  };
}
