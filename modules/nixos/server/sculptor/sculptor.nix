{ pkgs, globals, ... }:

{
  services.sculptor = {
    enable = globals.server.dns.exists;
    config = {
      listen.port = 25575;
    };
  };
  environment.persistence."/nix/host/state/Servers/Sculptor".directories = [
    { directory = "/var/lib/private/sculptor"; mode = "0700"; }
  ];
}