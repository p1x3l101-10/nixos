{ config, pkgs, lib, ... }:
let
  defaultRuntime = "WiVRn";
  monadoHelperShell = pkgs.writeShellScriptBin "setup-monado-handModels.sh" ''
    mkdir -p ~/.local/share/monado
    cd ~/.local/share/monado
    git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models
  '';
in
lib.mkIf (config.networking.hostName == "pixels-pc") {
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
  # WiVRn
  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = (defaultRuntime == "WiVRn");
    autoStart = true;
    config = {
      enable = true;
      json = {
        scale = 1.0;
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
  # Kernel patches
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];
  # CoreCTRL
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xfffd7fff";
    };
  };
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
    monadoHelperShell
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
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  system.allowedUnfree.packages = [
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
  networking.firewall.allowedUDPPorts = [ 9943 9944 9945 9946 9947 9949 5353 ];
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true; # optional since you're managing firewall yourself
  };
  environment.etc."nsswitch.conf".text = ''
    hosts: files mdns4_minimal [NOTFOUND=return] dns
  '';
}
