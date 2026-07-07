{ pkgs, lib, eLib, ... }:

let
  pwCfg = attrs: eLib.attrsets.compressAttrs "." attrs;
in {
  services.pulseaudio.enable = false;
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire = {
      "99-fix-crackling" = {
        "context.properties" = pwCfg {
          default.clock = {
            rate = 48000;
            allowed-rates = [ 44100 48000 88200 96000 ];
            min-quantum = 32;
            max-quantum = 2048;
          };
        };
      };
    };
  };
  environment.systemPackages = [ pkgs.pipewire ];
}
