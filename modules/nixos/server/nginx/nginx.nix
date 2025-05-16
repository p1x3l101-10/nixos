{ lib, globals, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = globals.dns.exists;
    virtualHosts."_" = { # The default landing page
      enableACME = false;
      locations."/".root = lib.mkDefault ./landing;
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
  ] ++ (lib.optionals globals.dns.exists [ 443 ]); # Only open https when we can actually use it
}