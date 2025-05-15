{ pkgs, ... }:

{
  services.sculptor = {
    enable = true;
    openFirewall = true;
    config = {
      listen.port = 25576;
    };
  };
  environment.persistence."/nix/host/state/Servers/Sculptor".directories = [
    { directory = "/var/lib/private/sculptor"; mode = "0700"; }
  ];
}