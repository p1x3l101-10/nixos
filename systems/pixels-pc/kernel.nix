{ lib, pkgs, eLib, ... }:

let
  kernel = pkgs.linuxKernel.packages.linux_zen;
  hostArch = "znver3";
  cfg = let
    kOpts = with lib; with lib.kernel; (fix (final: {
      yes = mkForce yes;
      no = mkForce no;
      freeform = x: mkForce (freeform x);
      module = mkForce module;
      unset = mkForce unset;
      y = final.yes;
      n = final.no;
      m = final.module;
      u = final.unset;
      ff = final.freeform;
    }));
    llvmKernelStdenv = pkgs.stdenvAdapters.overrideInStdenv pkgs.llvmPackages.stdenv (with pkgs; [
      llvm
      lld
      llvmPackages.clang-unwrapped
    ]);
  in eLib.attrsets.mergeAttrs (map
    (x:
      {
        overrides = if (builtins.hasAttr "overrides" x) then x.overrides else {};
        patches = (if (builtins.hasAttr "patches" x) then x.patches else []) ++ (lib.mapAttrsToList
          (name: structuredExtraConfig: {
            inherit name structuredExtraConfig;
            patch = null;
          })
          (if (builtins.hasAttr "config" x) then x.config else {})
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
          DEBUG_INFO = u;
          DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = n;
          DEBUG_INFO_REDUCED = u;
          DEBUG_INFO_BTF = u;
          # DEBUG_KERNEL = n; # TODO: Find dependancy that still needs this
          DYNAMIC_DEBUG = n;
          PROFILING = n;
          CRASH_DUMP = n;
          SUNRPC_DEBUG = n;
          SECURITY_IPE = n;
          IPE_PROP_FS_VERITY = u;
          IPE_PROP_FS_VERITY_BUILTIN_SIG = u;
          BPF_LSM = n;
          SCHEDSTATS = n;
          IRQ_TIME_ACCOUNTING = n;
          PARAVIRT_TIME_ACCOUNTINT = u;
          NETCONSOLE = n;
          NETCONSOLE_DYNAMIC = u;
          PRINTK_INDEX = n;
        };
      }
      # Hijack Archlinux's qr code decompressor
      {
        config."blatant-qr-theft" = with kOpts; {
          DRM_PANIC = y;
          DRM_PANIC_SCREEN = ff "qr_code";
          DRM_PANIC_SCREEN_QR_CODE = y;
          DRM_PANIC_SCREEN_QR_CODE_URL = ff "https://panic.archlinux.org/panic_report#";
        };
      }
      # Make my panic look not BSOD
      {
        config."no-bsod" = with kOpts; {
          DRM_PANIC_FOREGROUND_COLOR = ff "0xffffff";
          DRM_PANIC_BACKGROUND_COLOR = ff "0xff0000";
        };
      }
      # Fix some dependancy issues
      {
        config."fix-dependancy-issues" = with kOpts; {
          # Unknown
          MITIGATION_SLS = u;
          NOVA_CORE = u;
          DRM_NOVA = u;
          NET_SCH_BPF = u;
          PROC_VMCORE = u;
          SCHED_CLASS_EXT = u;
        };
      }
    ]
  );
in {
  boot = {
    kernelPatches = cfg.patches;
    kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (kernel.kernel.override cfg.overrides));
  };
  # Disable services that are borked by kconfig
  security.audit.enable = false;
}
