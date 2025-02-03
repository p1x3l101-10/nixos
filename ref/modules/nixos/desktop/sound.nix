{ config, lib, ... }:
{
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
