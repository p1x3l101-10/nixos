{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.kernels.linux_zen;
}