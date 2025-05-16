{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      enableACME = false;
      locations."/".root = ./landing;
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}