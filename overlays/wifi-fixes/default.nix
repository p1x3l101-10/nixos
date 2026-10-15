{ infuse, ... }:

final: prev: infuse prev {
  wpa_supplicant.__output.extraConfig.__append = "CONFIG_WEP=y";
}
