{ lib, pkgs, inputs, ... }:
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
  services.printing.enable = true;
  services.xserver = {
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
  services.displayManager.defaultSession = "gnome";

  services.gnome.games.enable = false;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;

  environment.gnome = {
    excludePackages = with pkgs; [
      gnome-extension-manager
      gnome-shell-extensions
    ];
  };
  services.gnome.gnome-initial-setup.enable = true;
  programs.nautilus-open-any-terminal.enable = true;
  programs.gnome-disks.enable = true;
  services.gnome.sushi.enable = true;
  environment.systemPackages = with pkgs; [
    nautilus
    gnome-software
    morewaita-icon-theme
    wl-clipboard # Clipboard needed for wayland
  ];
  programs.ssh.enableAskPassword = false;
  documentation.nixos.enable = false;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
