{ pkgs, lib, config, ... }:

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
  # Greeter
  services.greetd = {
    enable = true;
    settings = rec {
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
     cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    settings = {
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
      widget.clock.format = "%I:%M:%S %P";
    };
  };
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/regreet"
  ];
})
