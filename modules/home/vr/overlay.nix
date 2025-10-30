{ pkgs, ... }:

let
  wivrnAudioToggle = pkgs.callPackage ./support/wivrnAudioFixer.nix {};
in {
  xdg.configFile = {
    "wlxoverlay/keyboard.yaml".source = (pkgs.formats.yaml { }).generate "keyboard.yaml" (import ./support/wlx-keyboard.nix);
    "wlxoverlay/settings.yaml".source = (pkgs.formats.yaml { }).generate "settings.yaml" (import ./support/wlx-settings.nix);
    "wlxoverlay/watch.yaml".source = (pkgs.formats.yaml { }).generate "watch.yaml" (import ./support/wlx-watch.nix { audioToggleBin = "${wivrnAudioToggle}/bin/toggle"; });
    "wlxoverlay/wayvr.conf.d/dashboard.yaml".source = (pkgs.formats.yaml { }).generate "dashboard.yaml" (import ./support/wayvr-dash.nix { mainProg = "${pkgs.wayvr-dashboard}/bin/wayvr-dashboard"; });
    "wlxoverlay/wayvr.conf.d/settings.yaml".source = (pkgs.formats.yaml { }).generate "dashboard.yaml" (import ./support/wayvr-settings.nix);
  };
}
