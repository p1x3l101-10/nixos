{ ... }:

{
  services.sculptor = {
    enable = true;
    openFirewall = true;
    config = {
      listen.port = 4443; # Exposed on 7002
    };
  };
  environment.persistence."/nix/host/state/Servers/Sculptor".directories = [
    { directory = "/var/lib/private/sculptor"; mode = "0700"; }
  ];
}