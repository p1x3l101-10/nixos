{ ... }:

{
  networking.wireless = {
    enable = true;
    secretsFile = "/nix/host/keys/wpa_supplicant/secrets.conf";
    networks = {
      "NSA Surveillance Hub5" = {
        psk = "ext:psk_home_main";
        priority = 10;
      };
    };
  };
}
