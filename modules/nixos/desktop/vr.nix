{ config, pkgs, lib, ... }:
lib.mkIf (config.networking.hostName == "pixels-pc") {
  # Main vr service
  services.wivrn = {
    enable = true;
    defaultRuntime = true;
    autoStart = true;
    openFirewall = true;
    config = {
      enable = true;
      json = {
        scale = [
          0.5
          0.5
        ];
        bitrate = (
          50 # Bitrate in Mb/s
          * 1000000 # Scalor
        );
        encoders = [
          {
            encoder = "vulkan";
            codec = "h264";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
        application = [ pkgs.wlx-overlay-s ]; # Autolaunch my overlay
        tcp-only = false;
        openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
      };
    };
  };
  # GPU Userspace temp overclocking
  hardware.amdgpu.overdrive = {
    enable = true;
    ppfeaturemask = "0xfffd7fff";
  };
  # CoreCTRL
  programs.corectrl.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.corectrl.helper.init" ||
            action.id == "org.corectrl.helperkiller.init") &&
            subject.local == true &&
            subject.active == true &&
            subject.isInGroup("wheel")) {
                return polkit.Result.YES;
            }
        }
    );
  '';
  # Others
  environment.systemPackages = with pkgs; [
    immersed
    xr-hardware
    internal.telescope
    libva
    opencomposite
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  system.allowedUnfree.packages = [
    # Needed for an app
    "immersed"
    # Agree only to these packages, not the "CUDA Toolkit End User License Agreement (EULA)" as a whole
    "cuda-merged"
    "cuda_cccl"
    "cuda_cudart"
    "cuda_cuobjdump"
    "cuda_cupti"
    "cuda_cuxxfilt"
    "cuda_gdb"
    "cuda_nvcc"
    "cuda_nvdisasm"
    "cuda_nvml_dev"
    "cuda_nvprune"
    "cuda_nvrtc"
    "cuda_nvtx"
    "cuda_profiler_api"
    "cuda_sanitizer_api"
    "libcublas"
    "libcufft"
    "libcurand"
    "libcusolver"
    "libcusparse"
    "libnpp"
    "libnvjitlink"
  ];
  nixpkgs.config = {
    #xr.enable = false;
    rocmSupport = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };
  # Autostart the VR client when connected
  # Match the device
  services.udev.extraRules = let
    runCommand = lib.strings.concatStringsSep " " [
      "${config.systemd.package}/bin/systemctl"
      "--machine=${config.users.users.pixel.name}@.host"
      "--user"
      "start"
      "wivrn-launch.service"
    ];
  in ''
    # Autostart wired vr
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_VENDOR}=="Oculus", ENV{ID_USB_MODEL}=="Quest_3", RUN+="${runCommand}"
  '';
  # Write the systemd service
  systemd.user.services.wivrn-launch = {
    requires = [ "default.target" ];
    path = with pkgs; [
      android-tools
    ];
    enableStrictShellChecks = true;
    script = ''
      sleep 2  # give adb a moment

      adb reverse tcp:9757 tcp:9757 # Port forwarding over the cable
      adb shell am start -a android.intent.action.VIEW -d "wivrn+tcp://localhost" org.meumeu.wivrn # Start the wivrn client
    '';
  };
}
