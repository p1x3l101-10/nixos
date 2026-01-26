{ pkgs, ... }@args:

let
  wivrnAudioToggle = pkgs.callPackage ./support/wivrnAudioFixer.nix {};
in {
  xdg.configFile = {
    "wayvr/keyboard.yaml".source = (pkgs.formats.yaml { }).generate "keyboard.yaml" (import ./support/wayvr-keyboard.nix);
    "wayvr/conf.d/home-manager.yaml".source = (pkgs.formats.yaml { }).generate "wayvr-config.yaml" (import ./support/wayvr-config.nix args);
  };
  home.packages = [
    pkgs.cage # Needed for XWayland in the dashboard
  ];
}
