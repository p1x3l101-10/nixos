inputs: let
  lib = inputs.snowfall-lib.mkLib {
    inherit inputs;
    src = ./.;
  };
in lib.mkFlake {
  systems = {
    # Generate registries
    nixos.modules = [{
      nix.settings.registry = lib.internal.confTemplates.registry inputs;
    }];
    hosts = {
      pixels-pc.modules = with inputs; [
        nixpkgs-xr.nixosModules.nixpkgs-xr
      ] ++ (with nixos-hardware.nixosModules;[
        common-pc
        common-pc-ssd
        common-cpu-amd
        common-gpu-amd
      ]);
    };
  };
  supportedSystems = [ "x86_64-linux" ];
  outputs-builder = channels: {
    formatter = channels.nixpkgs.nixpkgs-fmt;
  };
  alias = {
    modules.nixos.default = "base";
    overlays.default = "nixos-rebuild";
  };
  channels-config = {
    contentAddressedByDefault = true;
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
