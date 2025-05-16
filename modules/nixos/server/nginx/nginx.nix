{ config, lib, globals, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = globals.server.dns.exists;
    virtualHosts."_" = if
        (config.services.nginx.virtualHosts."${globals.server.dns.basename}" == {}) # Redirect to normal website when it actually exists
      then
        { # The default landing page
          enableACME = lib.mkDefault false;
          locations."/".root = lib.mkDefault ./landing;
        }
      else {
        globalRedirect = globals.server.dns.basename;
      }
    ;
  };
  networking.sshForwarding.ports = [
    { host = 80; remote = 8080; }
  ] ++ (lib.optionals globals.server.dns.exists [ # Only open https when we can actually use it
    { host = 443; remote = 4443; }
  ]);
}