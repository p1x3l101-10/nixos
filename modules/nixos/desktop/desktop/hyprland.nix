{ pkgs, lib, ext, ... }:

lib.fix (self: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  services.udisks2.enable = true;
  programs.uwsm.enable = true;
  # Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = ""; # ReGreet provides a (basic) default here
        user = "greeter";
      };
    };
  };
  users.extraUsers.greeter = {
    isSystemUser = true;
    home = "/var/lib/greetd";
    createHome = true;
  };
  programs.regreet = {
    enable = true;
    settings = {
      background.path = ext.assets.img."login.png";
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
      widget.clock.format = "%I:%M:%S %P";
    };
  };
})
