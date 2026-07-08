{ ... }:

{
  hardware.enableRedistributableFirmware = true;
  networking.wireless = {
    enable = true;
    secretsFile = "/nix/host/keys/wpa_supplicant/secrets.conf";
    networks = {
      "NSA Surveillance Hub5" = {
        pskRaw = "ext:psk_home_main";
        authProtocols = [ "WPA-PSK" ];
        priority = 10;
      };
      "Blatt Wifi" = {
        pskRaw = "ext:psk_paps";
        authProtocols = [ "WPA-PSK" ];
        priority = 5;
      };
    };
  };
  # Prevent wait-online from killing my boot speed when offline
  boot.initrd.systemd.network.wait-online.timeout = 5;
  systemd.network.wait-online.timeout = 5;
}
