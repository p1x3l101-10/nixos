{ ... }:

{
  services.sculptor = {
    enable = true;
    openFirewall = true;
    config = {
      listen.port = 25575; # Exposed on 25575
    };
  };
  environment.persistence."/nix/host/state/Servers/Sculptor".directories = [
    { directory = "/var/lib/private/sculptor"; mode = "0700"; }
  ];
}