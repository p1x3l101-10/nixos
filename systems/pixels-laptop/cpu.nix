{ lib, ... }:

let
  gccArches = [
    "i386" "i486" "i586" "pentium" "lakemont" "pentium-mmx" "winchip-c6" "winchip2" "c3" "samuel-2" "c3-2" "nehemiah" "c7" "esther" "i686" "pentiumpro" "pentium2" "pentium3" "pentium3m" "pentium-m" "pentium4" "pentium4m" "prescott" "nocona" "core2" "nehalem" "corei7" "westmere" "sandybridge" "corei7-avx" "ivybridge" "core-avx-i" "haswell" "core-avx2" "broadwell" "skylake" "skylake-avx512" "cannonlake" "icelake-client" "rocketlake" "icelake-server" "cascadelake" "tigerlake" "cooperlake" "sapphirerapids" "emeraldrapids" "alderlake" "raptorlake" "meteorlake" "graniterapids" "graniterapids-d" "bonnell" "atom" "silvermont" "slm" "goldmont" "goldmont-plus" "tremont" "gracemont" "sierraforest" "grandridge" "knl" "knm" "intel" "geode" "k6" "k6-2" "k6-3" "athlon" "athlon-tbird" "athlon-4" "athlon-xp" "athlon-mp" "x86-64" "x86-64-v2" "x86-64-v3" "x86-64-v4" "eden-x2" "nano" "nano-1000" "nano-2000" "nano-3000" "nano-x2" "eden-x4" "nano-x4" "lujiazui" "k8" "k8-sse3" "opteron" "opteron-sse3" "athlon64" "athlon64-sse3" "athlon-fx" "amdfam10" "barcelona" "bdver1" "bdver2" "bdver3" "bdver4" "znver1" "znver2" "znver3" "znver4" "btver1" "btver2" "generic"
  ];
in {
  /* Make builds the same again
    nixpkgs.system = lib.mkForce {
    features = [ "gccarch-skylake" ];
    system = "x86_64-linux";
    gcc = {
      arch = "skylake";
      tune = "skylake";
    };
    };
  */
  nixpkgs.buildPlatform.systemFeatures = lib.forEach (x: "gccarch-" + x) gccArches;
}
