final: prev: {
  wpa_supplicant = prev.wpa_supplicant.overrideAttrs (old: {
    extraConfig = (old.extraConfig or "") + ''
      CONFIG_WEP=y
    '';
  });
}
