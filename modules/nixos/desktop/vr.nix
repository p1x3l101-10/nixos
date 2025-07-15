{ config, pkgs, lib, ... }:
lib.mkIf (config.networking.hostName == "pixels-pc") {
  # Envision
  programs.envision = {
    enable = true;
    #package = pkgs.internal.envision;
    openFirewall = true;
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
    opencomposite
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
}
