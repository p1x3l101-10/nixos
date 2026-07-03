{ lib, pkgs, eLib, ... }:

let
  kernel = pkgs.linuxKernel.packages.linux_zen;
  hostArch = "znver3";
  cfg = let
    kOpts = with lib; with lib.kernel; (fix (final: {
      yes = mkForce yes;
      no = mkForce no;
      freeform = mkForce freeform;
      module = mkForce module;
      unset = mkForce unset;
      y = final.yes;
      n = final.no;
      m = final.module;
      u = final.unset;
    }));
    llvmKernelStdenv = pkgs.stdenvAdapters.overrideInStdenv pkgs.llvmPackages.stdenv (with pkgs; [
      llvm
      lld
      llvmPackages.clang-unwrapped
    ]);
  in eLib.attrsets.mergeAttrs (map
    (x:
      {
        inherit (x) overrides;
        patches = x.patches ++ (lib.mapAttrsToList
          (name: structuredExtraConfig: {
            inherit name structuredExtraConfig;
            patch = null;
          })
        );
      }
    )
    [
      # Use LLVM instead of GNU toolchain
      {
        config."llvm-lto" = with kOpts; {
          CPU_MITIGATIONS = n; # Not k8s server
          CC_IS_CLANG = y;
          LTO = y;
          LTO_CLANG = y;
          LTO_CLANG_THIN = y; # Massivly save on build time in exchange for only 90% of possible gains
        };
        overrides = {
          extraMakeFlags = [
            "KCFLAGS+=-O3"
            "KCFLAGS+=-mtune=${hostArch}"
            "KCFLAGS+=-march=${hostArch}"
            "KCFLAGS+=-Wno-unused-command-line-argument"
            "CC=${pkgs.llvmPackages.clang-unwrapped}/bin/clang"
            "AR=${pkgs.llvm}/bin/llvm-ar"
            "NM=${pkgs.llvm}/bin/llvm-nm"
            "LD=${pkgs.lld}/bin/ld.lld"
            "LLVM=1"
          ];
          stdenv = llvmKernelStdenv;
        };
      }
      # Disable some debugging stuff that causes notable performance hits
      {
        config."no-debugging-symbols" = with kOpts; {
          DEBUG_KERNEL = n;
          PROFILING = n;
          AUDIT = n;
        };
      }
    ]
  );
in {
  boot = {
    kernelPatches = cfg.patches;
    kernelPackages = pkgs.linuxPackagesFor (kernel.override cfg.overrides);
  };
}
