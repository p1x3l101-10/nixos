{ lib, pkgs, ... }:
{
  # Posix shell
  environment.binsh = "${pkgs.dash}/bin/dash";

  # Bootloader
  services.fwupd.enable = true;
  boot = {
    loader = {
      timeout = lib.mkDefault 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      systemd-boot = {
        enable = true;
        editor = false;
        netbootxyz.enable = true;
        edk2-uefi-shell.enable = true;
      };
    };
    initrd.systemd.enable = true;
    uki.tries = 1;
  };

  # Nix settings (and git for flakes)
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nixVersions.nix_2_30;
  };
  environment.systemPackages = [
    pkgs.internal.rebuild
  ];
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitMinimal;
  };

  # Networking
  networking.networkmanager.enable = true;

  # Clutter
  programs.nano.enable = lib.mkDefault false;

  # Needed, don't change unless absolutly needed (never)
  system.stateVersion = "24.11";
}
