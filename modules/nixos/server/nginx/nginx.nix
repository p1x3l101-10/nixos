{ config, lib, globals, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = globals.server.dns.exists;
    recommendedGzipSettings = true;
    recommendedOptimizationSettings = true;
    virtualHosts."_" = (
      if
        globals.server.www.exists # Redirect to normal website when it actually exists
      then
        {
          globalRedirect = globals.server.dns.basename;
        }
      else
        { # The default landing page
          enableACME = lib.mkDefault false;
          locations."/".root = lib.mkDefault ./landing;
        }
      )
    ;
  };
  networking.sshForwarding.ports = [
    { host = 80; remote = 8080; }
  ] ++ (lib.optionals globals.server.dns.exists [ # Only open https when we can actually use it
    { host = 443; remote = 4443; }
  ]);
}