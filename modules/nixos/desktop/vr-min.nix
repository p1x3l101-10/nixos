{ config, lib, pkgs, ... }:

lib.mkIf (config.networking.hostName == "pixels-pc") {
  networking.firewall = {
    allowedUDPPorts = [
      9943
      9944
      9945
      9946
      9947
      9949
      5353
    ];
    allowedTCPPorts = [
      9943
      9944
      5353
      9757
    ];
  };
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  nixpkgs.config = {
    xr.enable = true;
    rocmSupport = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };
}