inputs: inputs.snowfall-lib.mkFlake {
  systems = {
    modules.nixos = with inputs; [
      lanzaboote.nixosModules.lanzaboote
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
    ];
    hosts = {
      pixels-pc.modules = with inputs; [
        nixpkgs-xr.nixosModules.nixpkgs-xr
      ];
    };
  };
  inherit inputs;
  src = ./.;
  supportedSystems = [ "x86_64-linux" ];
  outputs-builder = channels: {
    formatter = channels.nixpkgs.nixpkgs-fmt;
  };
  channels-config = {
    #contentAddressedByDefault = true;
    # List of unfree packages to allow
    # I could enable them all using one config, but that seems unsafe...
    # Make packages work using this one simple trick, Stallman hates him!
    allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
      # Holy crap, thats a lot of cuda things lol
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
      # Steam dev stuff
      "steam-unwrapped"
    ];
  };
}