{ config, pkgs, lib, ... }:
lib.mkIf (config.networking.hostName == "pixels-pc") (let
  systemctl = config.systemd.package.overrideAttrs (oldAttrs: {
    meta.mainProgram = "systemctl";
  });
in {
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
        application = [
          systemctl "--user" "start" "virtualReality.target" # Start the vr target
        ];
        tcp-only = false;
        openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
      };
    };
  };
  # Vr target
  systemd.user.targets.virtualReality = lib.fix (self: {
    requires = [
      "graphical-session.target"
    ];
    after = self.requires;
  });
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
    stopCommand = lib.strings.concatStringsSep " " [
      "${config.systemd.package}/bin/systemctl"
      "--machine=${config.users.users.pixel.name}@.host"
      "--user"
      "stop"
      "wivrn-launch.service"
    ];
    questUdev = ''SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_VENDOR}=="Oculus", ENV{ID_USB_MODEL}=="Quest_3", ENV{adb_user}=="yes"'';
  in ''
    # Autostart wired vr
    ACTION=="add", ${questUdev}, RUN+="${runCommand}"
    ACTION=="remove", ${questUdev}, RUN+="${stopCommand}"
  '';
  # Write the systemd service
  systemd.user.services.wivrn-launch = {
    requires = [ "wivrn.service" ];
    path = with pkgs; [
      android-tools
      config.systemd.package
    ];
    enableStrictShellChecks = true;
    serviceConfig.Type = "oneshot";
    script = ''
      echo "Attempting to connect..."
      for i in $(seq 1 10); do
        echo "Try $i"
        if adb devices | grep -q "device$"; then # Test for connection
          echo "Device detected, starting streaming"
          adb reverse tcp:9757 tcp:9757 # Port forwarding over the cable
          adb shell am start -a android.intent.action.VIEW -d "wivrn+tcp://localhost" org.meumeu.wivrn # Start the wivrn client
          exit 0
        else
          sleep 10
        fi
      done
      echo "Max tries exceeded."
      echo "Quest 3 is not set up to allow ADB!"
      exit 1
    '';
    postStop = ''
      systemctl --user stop virtualReality.target
      systemctl --user restart wivrn.service
    '';
  };
})
