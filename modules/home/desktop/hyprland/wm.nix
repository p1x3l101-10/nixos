{ pkgs, config, ... }@args:

let
  loadCfg = config: import (./support/settings + "/${config}.nix") args;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    # Nixos manages these packages
    package = null;
    portalPackage = null;
    configType = "lua";
    settings = loadCfg "hyprland";
    xdph.settings = loadCfg "xdph";
    systemd.enable = false;
  };
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
