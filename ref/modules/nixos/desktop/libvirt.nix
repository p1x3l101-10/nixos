{ lib, ... }:
{
  virtualisation.spiceUSBRedirection.enable = lib.mkDefault true; # USB, note: unpriv access to usb devices
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true; # UEFI
      swtpm.enable = true; # TPM
    };
  };
}
