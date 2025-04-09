{ lib, pkgs, ... }:
{
  # Posix shell
  environment.binsh = "${pkgs.dash}/bin/dash";

  # Bootloader
  services.fwupd.enable = true;
  boot = {
    loader = {
      timeout = lib.mkDefault 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      systemd-boot = {
        enable = true;
        editor = false;
        netbootxyz.enable = true;
      };
    };
    initrd.systemd.enable = true;
  };

  # Nix settings (and git for flakes)
  nix = {
    package = pkgs.internal.only-nix3;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
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
  #networking.useNetworkd = true;
  #systemd.network.enable = true;

  # Clutter
  programs.nano.enable = lib.mkDefault false;

  # Nice to have
  services.envfs.enable = true;

  # Needed, don't change unless absolutly needed (never)
  system.stateVersion = "24.11";
}
