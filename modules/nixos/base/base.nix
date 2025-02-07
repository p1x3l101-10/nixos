{ lib, pkgs, ... }:
{
  environment.binsh = "${pkgs.dash}/bin/dash";

  services.fwupd.enable = true;
  boot.loader = {
    timeout = lib.mkDefault 3;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    systemd-boot = {
      enable = true;
      editor = false;
    };
  };
  boot.initrd.systemd.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = (pkgs.callPackage ../../../packages/only-nix3 {});
  environment.systemPackages = [
    (pkgs.callPackage ../../../packages/rebuild {})
  ];
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitMinimal;
  };

  networking.networkmanager.enable = true;
  #networking.useNetworkd = true;
  #systemd.network.enable = true;

  programs.nano.enable = lib.mkDefault false;

  nix.settings.auto-optimise-store = true;

  services.envfs.enable = true;

  system.stateVersion = "24.11";
}
