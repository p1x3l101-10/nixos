{ pkgs, ... }:

{
  xdg.configFile = {
    "wlxoverlay/conf.d/keyboard.yaml".source = (pkgs.formats.yaml { }).generate "keyboard.yaml" (import ./support/wlx-keyboard.nix);
    "wlxoverlay/conf.d/settings.yaml".source = (pkgs.formats.yaml { }).generate "settings.yaml" (import ./support/wlx-settings.nix);
    "wlxoverlay/conf.d/watch.yaml".source = (pkgs.formats.yaml { }).generate "watch.yaml" (import ./support/wlx-watch.nix);
  };
}
