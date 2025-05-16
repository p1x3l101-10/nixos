{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."_" = {
      enableACME = true;
      locations."/".root = ./landing;
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}