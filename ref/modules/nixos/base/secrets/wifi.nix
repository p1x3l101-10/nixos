{ config, ... }:
{
  sops.secrets.wifi = {
    sopsFile = ./data/wifi.env;
    format = "dotenv";
  };

  networking.wireless.environmentFile = config.sops.secrets.wifi.path;
  networking.wireless.networks = {
    "NPS".psk = "@NPS@";
    "NSA Surveillance Hub5".psk = "@NSA_SURVEILLANCE_HUB@";
    "NSA Surveillance Hub2".psk = "@NSA_SURVEILLANCE_HUB@";
    "Bar of Silicon".psk = "@BAR_OF_SILICON@";
  };
}
