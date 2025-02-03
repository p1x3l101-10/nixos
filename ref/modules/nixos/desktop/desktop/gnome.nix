{ lib, pkgs, ... }:
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

  services.gnome.games.enable = true;
  services.gnome.core-utilities.enable = true;
  # services.gnome.core-developer-tools.enable = true; #libpeas2 will not build ATM

  environment.gnome = {
    excludePackages = (with pkgs.gnome; [
      gnome-software # No imperitiveness
    ]) ++ (with pkgs; [
      gnome-extension-manager # Replaced
      gnome-console # Better Term
      gnome-tour # Constantly annoying
      # Replaced by home manager
      gnome.gnome-backgrounds
    ]);
  };
  programs.dconf.enable = true;
  programs.seahorse.enable = false; # Replaced

  environment.systemPackages = with pkgs; [
    gnome.nautilus
    blackbox-terminal
  ];
  programs.ssh.enableAskPassword = false;
}
