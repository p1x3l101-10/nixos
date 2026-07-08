final: prev: {
  wpa_supplicant = final.wpa_supplicant.overrideAttrs (old: {
    extraConfig = (old.extraConfig or "") + ''
      CONFIG_WEP=y
    '';
  });
}
