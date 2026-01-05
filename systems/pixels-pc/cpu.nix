{ lib, ... }:

let
  gccArches = [
  ];
in
{
  /* Make builds the same again
    nixpkgs.system = lib.mkForce {
    features = [ "gccarch-znver3" ];
    system = "x86_64-linux";
    gcc = {
      arch = "znver3";
      tune = "znver3";
    };
    };
  */
  # Add all supported compile targets
  nixpkgs.buildPlatform.systemFeatures = lib.forEach (x: "gccarch-" + x) gccArches;
  hardware = {
    cpu.amd.ryzen-smu.enable = true;
    hardware.amdgpu.initrd.enable = true;
  };
}
