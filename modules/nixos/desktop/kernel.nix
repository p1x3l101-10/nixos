{ ext, ... }:

let
  # Build failure on unstable right now
  inherit (ext.stable) pkgs;
in {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "usbcore.autosuspend=-1" ];
  };
}
