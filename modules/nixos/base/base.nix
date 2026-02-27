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
    package = pkgs.nixVersions.latest;
  };
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitMinimal;
  };

  # Networking
  systemd.network = {
    enable = true;
    wait-online.enable = true;
  };

  # DNS
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "true";
      DNSSEC = "true";
      LLMNR = "true";
      Domains = [ "~." ];
      FallbackDNS = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    };
  };

  # Disable Networking conflicts
  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = false;
    useDHCP = false;
    useNetworkd = true;
  };

  # Clutter
  programs.nano.enable = lib.mkDefault false;

  # Needed, don't change unless absolutly needed (never)
  system.stateVersion = "24.11";

  # Ensure that the private state directory has acceptable permissions for systemd
  systemd.tmpfiles.settings."00-fix-private-dir"."/var/lib/private".d = {
    user = "root";
    group = "root";
    mode = "0700";
  };
}
