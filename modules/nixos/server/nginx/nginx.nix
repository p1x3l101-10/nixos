{ lib, globals, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = globals.server.dns.exists;
    virtualHosts."_" = { # The default landing page
      enableACME = false;
      locations."/".root = lib.mkDefault ./landing;
    };
  };
  networking.sshForwarding.ports = [
    { host = 80; remote = 8080; }
  ] ++ (lib.optionals globals.server.dns.exists [ # Only open https when we can actually use it
    { host = 443; remote = 4443; }
  ]);
}