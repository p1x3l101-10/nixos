{ pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  networking.wireless = {
    enable = true;
    userControlled = true;
    secretsFile = "/nix/host/keys/wpa_supplicant/secrets.conf";
    networks = {
      "NSA Surveillance Hub5" = {
        pskRaw = "ext:psk_home_main";
        authProtocols = [ "WPA-PSK" ];
        priority = 10;
      };
      "Blatt Wifi" = {
        pskRaw = "ext:psk_paps";
        authProtocols = [ "SAE"  ];
        extraConfig = ''
          ieee80211w=2
        '';
        priority = 5;
      };
      "Bar of Ytterbium" = {
        pskRaw = "ext:hotspot";
        authProtocols = [ "WPA-PSK" ];
        priority = -1;
      };
    };
  };
  # Prevent wait-online from killing my boot speed when offline
  boot.initrd.systemd.network.wait-online.timeout = 5;
  systemd.network.wait-online.timeout = 5;
  # Add user to group for wifi info
  users.users.pixel.extraGroups = [ "wpa_supplicant" ];
}
