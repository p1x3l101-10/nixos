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
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks = {
      "10-wired" = {
        name = "enp8s0";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    llmnr = "true";
    dnsovertls = "true";
  };
  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    useNetworkd = true;
  };

  # Clutter
  programs.nano.enable = lib.mkDefault false;

  # Needed, don't change unless absolutly needed (never)
  system.stateVersion = "24.11";
}
