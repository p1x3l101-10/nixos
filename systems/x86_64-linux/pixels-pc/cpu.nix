{ lib, ... }:
{
  nixpkgs.system = lib.mkForce {
    features = [ "gccarch-znver3" ];
    system = "x86_64-linux";
    gcc = {
      arch = "znver3";
      tune = "znver3";
    };
  };
  hardware = {
    cpu.amd.ryzen-smu.enable = true;
    hardware.amdgpu.initrd.enable = true;
  };
}
