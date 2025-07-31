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
  # Greeter
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = lib.getBin config.programs.regreet.package;
        user = "greeter";
      };
      default_session = initial_session;
    };
  };
  programs.regreet = {
    enable = true;
    cageArgs = [
      "-s"
      "-m"
      "last"
    ];
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
