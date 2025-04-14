{ inputs, config, pkgs, lib, ... }:

{
  programs.dconf.profiles.gdm.databases = [{
    settings = {
      "org/gnome/desktop/peripherals/touchpad" = {
        speed = 0.35;
        disable-while-typing = false;
      };
      "org/gnome/interface".show-battery-percentage = true;
      "org/gnome/shell".last-selected-power-profile = "performance";
    };
  }];
  services = {
    printing = {
      enable = true;
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    xserver = {
      excludePackages = [ pkgs.xterm ];
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.defaultSession = "gnome";
    gnome = {
      games.enable = false;
      core-utilities.enable = false;
      core-developer-tools.enable = false;
      gnome-initial-setup.enable = true;
      sushi.enable = true;
      gnome-browser-connector.enable = true;
    };
    cntlm.netbios_hostname = config.networking.hostName;
    samba = {
      nsswins = true;
      nmbd.enable = true;
    };
  };
  programs = {
    ssh.enableAskPassword = false;
    gnome-disks.enable = true;
  };
  environment = {
    gnome = {
      excludePackages = with pkgs; [
        gnome-shell-extensions
      ];
    };
    systemPackages = with pkgs; [
      nautilus
      blackbox-terminal
      gnome-extension-manager
      inputs.zen-browser.packages."x86_64-linux".default
    ];
    persistence = {
      "/nix/host/state/System".directories = [
        "/var/lib/upower"
        "/var/lib/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/log" # Keep logs for later review
        "/var/lib/systemd"
        { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      ];
      "/nix/host/state/UserData".directories = [
        "/home"
      ];
    };
    etc = {
      "NetworkManager/system-connections".source = (pkgs.runCommand "empty-dir" {} "mkdir -p $out");
    };
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
  documentation.nixos.enable = false;
  systemd = {
    sysupdate = {
      enable = true;
      transfers = {
        "10-uki" = {};
        "20-bootloader" = {};
        "30-nix-store" = {};
      };
    };
  };
}