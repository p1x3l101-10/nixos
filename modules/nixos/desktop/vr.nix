{ config, pkgs, lib, ... }:
lib.mkIf (config.networking.hostName == "pixels-pc") {
  # Monado
  services.monado = {
    enable = true;
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
  # WiVRn
  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json = {
        # 1.0x foveation scaling
        scale = 1.0;
        # 100 Mb/s
        bitrate = 100000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            # 1.0 x 1.0 scaling
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
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
    wlx-overlay-s
    opencomposite
    xr-hardware
    stardust-xr-server
    stardust-xr-gravity
    stardust-xr-phobetor
    stardust-xr-magnetar
    stardust-xr-flatland
    stardust-xr-protostar
    stardust-xr-sphereland
    stardust-xr-atmosphere
    stardust-xr-kiara
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
    xr.enable = true;
    rocmSupport = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };
}
