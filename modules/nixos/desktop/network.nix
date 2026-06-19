{ ... }:

{
  networking.wireless = {
    enable = true;
    secretsFile = "/nix/host/keys/wpa_supplicant/secrets.conf";
    networks = {
      "NSA Surveillance Hub5" = {
        pskRaw = "ext:psk_home_main";
        authProtocols = [ "SAE" "WPA-PSK" ];
        priority = 10;
      };
    };
  };
}
