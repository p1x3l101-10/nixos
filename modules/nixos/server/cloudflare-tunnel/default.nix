{ globals, ... }:

{
  services.cloudflared = {
    enable = true;
    certificateFile = "${globals.dirs.keys}/cloudflared/cert.pem";
  };
}
