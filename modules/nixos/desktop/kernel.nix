{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "usbcore.autosuspend=-1" ];
  };
}
