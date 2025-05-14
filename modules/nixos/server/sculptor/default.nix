{ ... }:

{
  services.sculptor = {
    enable = true;
    openFirewall = true;
    config = {
      listen.port = 25575; # Exposed on 25575
    };
  };
}