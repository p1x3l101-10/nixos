{ config, ... }:
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    kernelModules = [
      "v4l2loopback"
    ];
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", ENV{V4L2_ALLOW_VIRTUAL_CAMERA}="1"
  '';
  security.polkit.enable = true;
}
