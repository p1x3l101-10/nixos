{ pkgs, config, ... }@args:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # Nixos manages these packages
    package = null;
    portalPackage = null;
    configType = "lua";
    settings = import ./support/settings/hyprland.nix args;
    systemd.enable = false;
  };
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
