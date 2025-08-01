{ pkgs, lib, ext, ... }:

let
  inherit (import ../../../home/desktop/hyprland/support/hypr-globals.nix pkgs lib) clockFormat;
in

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
        command = pkgs.writeShellScript "greeter" ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --cmd "uwsm start default" \
          --remember \
          --time \
          --time-format "${clockFormat.long}" \
          --power-shutdown "systemctl poweroff" \
          --power-reboot "systemctl reboot" \
          --asterisks \
          --power-no-setsid \
          --kb-power 1
        '';
        user = "greeter";
      };
    };
  };
  users.extraUsers.greeter = {
    isSystemUser = true;
    home = "/var/lib/greetd";
    createHome = true;
  };
})
